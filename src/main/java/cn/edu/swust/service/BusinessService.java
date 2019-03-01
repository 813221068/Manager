package cn.edu.swust.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import cn.edu.swust.dao.BusinessDao;
import cn.edu.swust.dao.DeclareBusinessDao;
import cn.edu.swust.dao.DeclareStepDao;
import cn.edu.swust.dao.StepDao;
import cn.edu.swust.dao.UserDao;
import cn.edu.swust.entity.Business;
import cn.edu.swust.entity.DeclareBusiness;
import cn.edu.swust.entity.Step;
import cn.edu.swust.query.BusinessQuery;
import cn.edu.swust.query.DeclareBusinessQuery;
import cn.edu.swust.query.DeclareStepQuery;
import cn.edu.swust.query.RolePermissionQuery;
import cn.edu.swust.query.StepQuery;
import cn.edu.swust.query.UserQuery;
import cn.edu.swust.util.LogHelper;

@Service
public class BusinessService {
	@Autowired
	private BusinessDao businessDao;
	@Autowired
	private UserDao userDao;
	@Autowired
	private StepDao stepDao;
	@Autowired
	private DeclareBusinessDao declareBusinessDao;
	@Autowired
	private DeclareStepDao declareStepDao;
	
	public List<Business> getBusinessList(BusinessQuery query){
		if(query!=null) {
			List<Business> list = businessDao.queryList(query);
			List<Business> businesses = new ArrayList<>();
			try {
				for(Business bsn : list) {
					UserQuery userQuery = new UserQuery();
					userQuery.setUserId(bsn.getCreateUserId());
					bsn.setCreateUser(userDao.query(userQuery));
					businesses.add(bsn);
				}
				
				return businesses;
			} catch (Exception e) {
				LogHelper.logError(e);
			}
			
		}
		return null;
	}
	/***
	 * 添加项目
	 * @param business  项目信息
	 * @param steps   项目审批过程 list
	 * @return
	 */
	@Transactional
	public int insertBusiness(Business business,List<Step> steps) {
		int ret = 0;
		try {
			businessDao.setPrimaryValue(1);
			ret = businessDao.insertOneSelective(business);
			stepDao.setPrimaryValue(1);
			stepDao.batchInsert(steps);
		} catch (Exception e) {
			LogHelper.logError(e);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ret = 0;
		}
		return ret;
	}
	/**
	 * 删除项目信息 
	 * @param query
	 * @return 影响行数
	 */
	@Transactional
	public int delete(BusinessQuery query) {
		int ret = 0;
		try {
			//todo 批量删除bug  修改删除项目的逻辑
			//逻辑：删除business表数据、删除step表数据、已经申报的项目不能删除
			StepQuery stepQuery = new StepQuery();
			DeclareBusinessQuery dclrBsnsQuery = new DeclareBusinessQuery();
			DeclareStepQuery dclrDlQuery = new DeclareStepQuery();
			if(query.getBusinessId()!=0) {
				stepQuery.setBusinessId(query.getBusinessId());
//				dclrBsnsQuery.setBusinessId(query.getBusinessId());
//				dclrDlQuery.setDeclareBusinessId(query.getBusinessId());
			}
			if(query.getBusinessIds()!=null && query.getBusinessIds().length>0) {
				stepQuery.setBusinessIds(query.getBusinessIds());
//				dclrBsnsQuery.setBusinessIds(query.getBusinessIds());
//				dclrDlQuery.setDeclareBusinessIds(query.getBusinessIds());
			}
			
//			declarestepDao.delete(dclrDlQuery);
//			declareBusinessDao.delete(dclrBsnsQuery);
			stepDao.delete(stepQuery);
			
			ret = businessDao.delete(query);
		}catch (Exception ex) {
			LogHelper.logError(ex);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ret = 0;
			
		}
		return ret;
	}
	/***
	 * 更新项目信息    
	 * @param business
	 * @param steps 只修改没有申报过的项目的审批流程
	 * @return
	 */
	public int update(Business business,List<Step> steps) {
		int result = 0;
		try {
			result = businessDao.updateByPrimaryKeySelective(business);
			
			if(steps!=null && steps.size()>0) {
				DeclareBusinessQuery dclBsnsQuery = new DeclareBusinessQuery();
				dclBsnsQuery.setBusinessId(business.getBusinessId());
				if(declareBusinessDao.queryList(dclBsnsQuery).size() == 0) {
					StepQuery stepQuery = new StepQuery();
					stepQuery.setBusinessId(business.getBusinessId());
					stepDao.delete(stepQuery);
					stepDao.setPrimaryValue(1);
					stepDao.batchInsert(steps);
				}
			}
			
		}catch (Exception e) {
			LogHelper.logError(e);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			result = 0;
		}
		return result;
	}
}
