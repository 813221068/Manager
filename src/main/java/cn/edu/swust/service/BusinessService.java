package cn.edu.swust.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.edu.swust.dao.BusinessDao;
import cn.edu.swust.dao.UserDao;
import cn.edu.swust.entity.Business;
import cn.edu.swust.query.BusinessQuery;
import cn.edu.swust.query.RolePermissionQuery;
import cn.edu.swust.query.UserQuery;
import cn.edu.swust.util.LogHelper;

@Service
public class BusinessService {
	@Autowired
	private BusinessDao businessDao;
	@Autowired
	private UserDao userDao;
	
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
	
	public int insertBusiness(Business business) {
		int row = 0;
		try {
			business.setBusinessId(businessDao.getMaxBsnID()+1);
			row = businessDao.insertOneSelective(business);
		} catch (Exception e) {
			LogHelper.logError(e);
		}
		return row;
	}
	/**
	 * 删除项目信息
	 * @param query
	 * @return 影响行数
	 */
	public int delete(BusinessQuery query) {
		if(query.isNull()) {
			return 0;
		}
		return businessDao.delete(query);
	}
	
	public int update(Business business) {
		try {
			if(business.getBusinessId()==0) {
				return 0;
			}
			return businessDao.updateByPrimaryKeySelective(business);
		} catch (Exception e) {
			LogHelper.logError(e);
		}
		return 0;
	}
}
