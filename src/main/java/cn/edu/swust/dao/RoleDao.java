package cn.edu.swust.dao;

import java.util.List;

import cn.edu.swust.entity.Permission;
import cn.edu.swust.entity.Role;
import cn.edu.swust.query.RoleQuery;

public interface RoleDao {

	public List<Role> queryList(RoleQuery query);
	/**
	 * 添加 返回rows
	 * @param role
	 * @return
	 */
	public int insertOne(Role role);
	
	public int getMaxRoleId();
	
	public List<Permission> queryPmsList(RoleQuery query);
	
	public int delete(RoleQuery query);
	/***
	 * 通过主键id 可选择性更新
	 * @param role
	 * @return 更新行数
	 */
	public int updateByPrimaryKeySelective(Role role);
}
