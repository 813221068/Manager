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
import cn.edu.swust.util.ObjectConvert;

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
//		if(query!=null) {
//			List<Business> list = businessDao.queryList(query);
//			List<Business> businesses = new ArrayList<>();
//			try {
//				for(Business bsn : list) {
//					UserQuery userQuery = new UserQuery();
//					userQuery.setUserId(bsn.getCreateUserId());
//					bsn.setCreateUser(userDao.query(userQuery));
//					businesses.add(bsn);
//				}
//				
//				return businesses;
//			} catch (Exception e) {
//				LogHelper.logError(e);
//			}
//			
//		}
		List<Business> businesses = new ArrayList<>();
		try {
			List<Business> list = businessDao.queryList(query);
			for(Business bsn : list) {
				UserQuery userQuery = new UserQuery();
				userQuery.setUserId(bsn.getCreateUserId());
				
				bsn.setCreateUser(userDao.query(userQuery));
				
				StepQuery stepQuery = new StepQuery();
				stepQuery.setBusinessId(bsn.getBusinessId());
				
				bsn.setSteps(stepDao.queryList(stepQuery));
				
				businesses.add(bsn);
			}
		} catch (Exception e) {
			LogHelper.logError(e);
		}
		return businesses;
	}
	/***
	 * 添加项目
	 * @param business  项目信息
	 * @param steps   项目审批过程 list
	 * @return  插入Id
	 */
	@Transactional
	public int insertBusiness(Business business,List<Step> steps) {
		int sltId = 0;
		try {
			if(business.getCreateUserId()==null||business.getCreateUserId()==""||steps==null||steps.size()==0) {
				return sltId;
			}
			
			businessDao.setPrimaryValue(1);
			sltId = businessDao.insertOneSelective(business);
			
			if(sltId != 0) {
				for(Step step : steps) {
					step.setBusinessId(sltId);
				}
				stepDao.setPrimaryValue(1);
				stepDao.batchInsert(steps);
			}
			
		} catch (Exception e) {
			LogHelper.logError(e);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			sltId = 0;
		}
		return sltId;
	}
	/**
	 * 批量删除  
	 * @param ids
	 * @return  0是全部失败  1是部分失败  2是全部成功
	 */
	public int batchDelete(int[] ids) {
		int successCount = 0;
		if(ids!=null && ids.length>0) {
			BusinessQuery query = new BusinessQuery();
			for(int id : ids) {
				query.setBusinessId(id);
				successCount += delete(query)>0?1:0;
			}
		}
		if(successCount==0) {
			return 0;
		}
		return successCount==ids.length?2:1;
	}
	/**
	 * 删除项目信息 删除business表数据、删除step表数据、已经申报的项目不能删除
	 * @param query
	 * @return 影响行数
	 */
	@Transactional
	public int delete(BusinessQuery query) {
		int ret = 0;
		try {
			//todo 批量删除bug  修改删除项目的逻辑
			
			DeclareBusinessQuery dclrBsnsQuery = new DeclareBusinessQuery();
			ObjectConvert.obj2Obj(query, dclrBsnsQuery);

			boolean isDeclare = declareBusinessDao.count(dclrBsnsQuery)==0?false:true;

			if(!isDeclare) {
				ret = businessDao.delete(query);
				StepQuery stepQuery = new StepQuery();
				ObjectConvert.obj2Obj(query, stepQuery);
				stepDao.delete(stepQuery);
			}
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
