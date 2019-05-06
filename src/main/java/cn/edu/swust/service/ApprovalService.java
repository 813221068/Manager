package cn.edu.swust.service;

import java.util.List;
import java.util.logging.Logger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import cn.edu.swust.RespEntity.AprvStepResp;
import cn.edu.swust.dao.BusinessDao;
import cn.edu.swust.dao.DeclareStepDao;
import cn.edu.swust.dao.StepDao;
import cn.edu.swust.dao.UserDao;
import cn.edu.swust.dao.UserRoleDao;
import cn.edu.swust.entity.DeclareStep;
import cn.edu.swust.query.AprvStepQuery;
import cn.edu.swust.query.BusinessQuery;
import cn.edu.swust.query.DeclareStepQuery;
import cn.edu.swust.query.UserQuery;
import cn.edu.swust.util.LogHelper;

@Service
public class ApprovalService {

	@Autowired
	private StepDao stepDao;
	@Autowired
	private UserDao userDao;
	@Autowired
	private BusinessDao businessDao;
	@Autowired
	private DeclareStepDao declareStepDao;
	
	public List<AprvStepResp> getAprvStepResps(AprvStepQuery query){
		List<AprvStepResp> list = null;
		try {
			list = stepDao.queryAprvStepResps(query);
			
			for (AprvStepResp aprvStepResp : list) {
				//封装user
				UserQuery userQuery = new UserQuery();
				userQuery.setUserId(aprvStepResp.getDeclareUserId());
				aprvStepResp.setDeclareUser(userDao.query(userQuery));
				//封装business
				BusinessQuery businessQuery = new BusinessQuery();
				businessQuery.setBusinessId(aprvStepResp.getBusinessId());
				aprvStepResp.setBusiness(businessDao.queryList(businessQuery).get(0));
			}
			
		} catch (Exception e) {
			LogHelper.logError(e);
		}
		
		return list;
	}
	
	public boolean doApproval(DeclareStep declareStep) {
		//todo 修改审批逻辑
		boolean ret = false; 
		try {
			ret = declareStepDao.updateByPrimaryKeySelective(declareStep)>0;
			
			DeclareStepQuery declareStepQuery = new DeclareStepQuery();
			declareStepQuery.setConnId(declareStep.getDeclareBusinessId());
			List<DeclareStep> list = declareStepDao.queryList(declareStepQuery);
			DeclareStep nextStep = null;
			for(int i=0;i<list.size();i++) {
				if(list.get(i).getConnId() == declareStep.getConnId()) {
					if((i+1)<list.size()) {
						nextStep = list.get(i+1);
					}
					break;
				}
			}
			if(nextStep!=null) {
				nextStep.setStatus(1);
				declareStepDao.updateByPrimaryKeySelective(nextStep);
			}
		} catch (Exception e) {
			LogHelper.logError(e);
			ret = false;
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		}
		return ret;
	}
}
