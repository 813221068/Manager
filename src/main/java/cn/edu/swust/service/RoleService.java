package cn.edu.swust.service;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.javassist.expr.NewArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
	
	public int addRole(Role role) {
		//设置id为最大id+1
		role.setRoleId(roleDao.getMaxRoleId()+1);
		int row = roleDao.insertOne(role);
		try {
			//添加角色-权限表
			if(row!=0) {
				for(Permission pms : role.getPmsList()) {
					RolePermission rolePermission = new RolePermission(rolePmsDao.getMaxId()+1,role.getRoleId(),
							pms.getPermissionId());
					rolePmsDao.insertOne(rolePermission);
				}
			}
			return row;
		} catch (Exception e) {
			LogHelper.logError(e);
		}
		
		return 0;
	}
	
	public int delete(RoleQuery query) {
		try {
			if(query.isNull()) {
				return 0;
			}
			//删除role表
			int row = roleDao.delete(query);
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
			}
			return row;
		} catch (Exception e) {
			LogHelper.logError(e);
		}
		return 0;
	}
	
	public int updateRole(Role role) {
		try {
			if(role.getRoleId()==0) {
				return 0;
			}
			int row = roleDao.updateByPrimaryKeySelective(role);
			//1 2 3 to 3 4 删除原来权限，在添加新权限 todo
			if(row != 0) {
				RolePermissionQuery rolePmsQuery = new RolePermissionQuery();
				rolePmsQuery.setRoleId(role.getRoleId());
				rolePmsDao.delete(rolePmsQuery);
				
				for(Permission pms:role.getPmsList()) {
					RolePermission rolePermission = new RolePermission();
					rolePermission.setConnId(rolePmsDao.getMaxId()+1);
					rolePermission.setRoleId(role.getRoleId());
					rolePermission.setPermissionId(pms.getPermissionId());
					
					rolePmsDao.insertOne(rolePermission);
					
				}
			}
			return row;
		} catch (Exception e) {
			LogHelper.logError(e);
		}
		return 0;
	}
}
