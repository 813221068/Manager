package cn.edu.swust.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import cn.edu.swust.dao.BusinessDao;
import cn.edu.swust.dao.DealDao;
import cn.edu.swust.dao.DeclareBusinessDao;
import cn.edu.swust.dao.DeclareDealDao;
import cn.edu.swust.dao.UserDao;
import cn.edu.swust.entity.Business;
import cn.edu.swust.entity.Deal;
import cn.edu.swust.entity.DeclareBusiness;
import cn.edu.swust.query.BusinessQuery;
import cn.edu.swust.query.DealQuery;
import cn.edu.swust.query.DeclareBusinessQuery;
import cn.edu.swust.query.DeclareDealQuery;
import cn.edu.swust.query.RolePermissionQuery;
import cn.edu.swust.query.UserQuery;
import cn.edu.swust.util.LogHelper;

@Service
public class BusinessService {
	@Autowired
	private BusinessDao businessDao;
	@Autowired
	private UserDao userDao;
	@Autowired
	private DealDao dealDao;
	@Autowired
	private DeclareBusinessDao declareBusinessDao;
	@Autowired
	private DeclareDealDao declareDealDao;
	
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
	 * @param deals   项目审批过程 list
	 * @return
	 */
	@Transactional
	public int insertBusiness(Business business,List<Deal> deals) {
		int ret = 0;
		try {
			businessDao.setPrimaryValue(1);
			ret = businessDao.insertOneSelective(business);
			dealDao.setPrimaryValue(1);
			dealDao.batchInsert(deals);
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
			//逻辑：删除business表数据、删除deal表数据、已经申报的项目不能删除
			DealQuery dealQuery = new DealQuery();
			DeclareBusinessQuery dclrBsnsQuery = new DeclareBusinessQuery();
			DeclareDealQuery dclrDlQuery = new DeclareDealQuery();
			if(query.getBusinessId()!=0) {
				dealQuery.setBusinessId(query.getBusinessId());
//				dclrBsnsQuery.setBusinessId(query.getBusinessId());
//				dclrDlQuery.setDeclareBusinessId(query.getBusinessId());
			}
			if(query.getBusinessIds()!=null && query.getBusinessIds().length>0) {
				dealQuery.setBusinessIds(query.getBusinessIds());
//				dclrBsnsQuery.setBusinessIds(query.getBusinessIds());
//				dclrDlQuery.setDeclareBusinessIds(query.getBusinessIds());
			}
			
//			declareDealDao.delete(dclrDlQuery);
//			declareBusinessDao.delete(dclrBsnsQuery);
			dealDao.delete(dealQuery);
			
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
	 * @param deals 只修改没有申报过的项目的审批流程
	 * @return
	 */
	public int update(Business business,List<Deal> deals) {
		int result = 0;
		try {
			result = businessDao.updateByPrimaryKeySelective(business);
			
			if(deals!=null && deals.size()>0) {
				DeclareBusinessQuery dclBsnsQuery = new DeclareBusinessQuery();
				dclBsnsQuery.setBusinessId(business.getBusinessId());
				if(declareBusinessDao.queryList(dclBsnsQuery).size() == 0) {
					DealQuery dealQuery = new DealQuery();
					dealQuery.setBusinessId(business.getBusinessId());
					dealDao.delete(dealQuery);
					dealDao.setPrimaryValue(1);
					dealDao.batchInsert(deals);
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
