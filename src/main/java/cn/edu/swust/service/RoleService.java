package cn.edu.swust.service;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.javassist.expr.NewArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import cn.edu.swust.dao.PermissionDao;
import cn.edu.swust.dao.RoleDao;
import cn.edu.swust.dao.RolePermissionDao;
import cn.edu.swust.dao.UserDao;
import cn.edu.swust.dao.UserRoleDao;
import cn.edu.swust.entity.Permission;
import cn.edu.swust.entity.Role;
import cn.edu.swust.entity.RolePermission;
import cn.edu.swust.entity.User;
import cn.edu.swust.query.PermissionQuery;
import cn.edu.swust.query.RolePermissionQuery;
import cn.edu.swust.query.RoleQuery;
import cn.edu.swust.query.UserQuery;
import cn.edu.swust.query.UserRoleQuery;
import cn.edu.swust.util.LogHelper;

@Service
public class RoleService {

	@Autowired
	private RoleDao roleDao;
	@Autowired
	private UserDao userDao;
	@Autowired
	private PermissionDao pmsDao;
	@Autowired
	private RolePermissionDao rolePmsDao;
	
	/**
	 *查询角色info
	 * @param query
	 * @return
	 */
	public List<Role> queryList(RoleQuery query){
		List<Role> roles = roleDao.queryList(query);
		List<Role> retList = new ArrayList<>();
		try {
			for(Role role : roles) {
				
				//创建人
				UserQuery userQuery = new UserQuery();
				userQuery.setUserId(role.getCreateUId());
				role.setCreateUser(userDao.query(userQuery));
				//封装permission
				PermissionQuery pmsQuery = new PermissionQuery();
				pmsQuery.setRoleId(role.getRoleId());
				role.setPmsList(pmsDao.queryPmsListByRole(pmsQuery));
				//封装owner
				userQuery = new UserQuery();
				userQuery.setRoleId(role.getRoleId());
				role.setOwners(userDao.getUserListByRole(userQuery));
				retList.add(role);
			}
		} catch (Exception e) {
			LogHelper.logError(e);
		}
		
		return retList;
	}
	/**
	 * 添加角色
	 * @param role
	 * @return id 0是失败
	 */
	@Transactional
	public int addRole(Role role) {
		int id = 0;
		//todo  事务回滚有bug  调用多个dao.method 只回滚最后一个
		try {
			roleDao.setPrimaryValue(1);
			id = roleDao.insertOne(role);
			
			//添加角色-权限表
			if(id != 0 && role.getPmsList()!=null && role.getPmsList().size()>0) {
				
				for(Permission pms : role.getPmsList()) {

					RolePermission rolePermission = new RolePermission();
					rolePermission.setRoleId(id);
					rolePermission.setPermissionId(pms.getPermissionId());
					
					rolePmsDao.setPrimaryValue(1);
					rolePmsDao.insertOne(rolePermission);
					
				}
			}
			
		}catch (Exception e) {
			LogHelper.logError(e);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			id = 0;
		}
		
		return id;
	}
	
	public int delete(RoleQuery query) {
		int row = 0;
		try {
			if(query.isNull()) {
				return 0;
			}
			//删除role表
			row = roleDao.delete(query);
			if(row!=0) {
				if(query.getRoleIds()!=null && query.getRoleIds().length!=0) {
					int[] ids = query.getRoleIds();
					for(int id:ids) {
						RolePermissionQuery rolePmsQuery = new RolePermissionQuery();
						rolePmsQuery.setRoleId(id);
						rolePmsDao.delete(rolePmsQuery);
					}
				}else {
					//删除role-permission表
					RolePermissionQuery rolePmsQuery = new RolePermissionQuery();
					rolePmsQuery.setRoleId(query.getRoleId());
					rolePmsDao.delete(rolePmsQuery);
				}
				//todo 更新删除角色逻辑  旧逻辑：只删除role和role_permission表数据 
				//没有处理 角色下用户信息   
			}
			return row;
		} catch (Exception e) {
			LogHelper.logError(e);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		}
		return row;
	}
	/**
	 * 更新role信息
	 * @param role
	 * @return row 
	 */
	public int updateRole(Role role,List<Permission> addPmsList) {
		int row = 0;
		try {
			if(role.getRoleId()==0) {
				return 0;
			}
			row = roleDao.updateByPrimaryKeySelective(role);
			if(row != 0) {
				RolePermissionQuery rolePmsQuery = new RolePermissionQuery();
				rolePmsQuery.setRoleId(role.getRoleId());
				
				List<RolePermission> oldPmsList = rolePmsDao.queryList(rolePmsQuery);
				
				for(RolePermission rolePms : oldPmsList) {
					boolean havePmsInTable = false;
					for(Permission pms : role.getPmsList()) {
						if(rolePms.getPermissionId() == pms.getPermissionId()) {
							havePmsInTable = true;
							break;
						}
					}
					//删除原来的权限
					if(!havePmsInTable) {
						RolePermissionQuery rpq = new RolePermissionQuery();
						rpq.setRoleId(role.getRoleId());
						rpq.setPermissionId(rolePms.getPermissionId());
						rolePmsDao.delete(rpq);
					}
				}
				
				for(Permission pms : addPmsList) {
					RolePermission rolePms = new RolePermission();
					rolePms.setPermissionId(pms.getPermissionId());
					rolePms.setRoleId(role.getRoleId());
					
					rolePmsDao.insertOne(rolePms);
				}
				
			}
		} catch (Exception e) {
			LogHelper.logError(e);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			row = 0;
		}
		return row;
	}
}
