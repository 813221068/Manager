package cn.edu.swust.dao;

import java.util.List;

import cn.edu.swust.entity.Permission;
import cn.edu.swust.entity.Role;
import cn.edu.swust.query.RoleQuery;

public interface RoleDao {

	public List<Role> queryList(RoleQuery query);
	/**
	 * 添加 
	 * @param role
	 * @return id  失败为0
	 */
	public int insertOne(Role role);
	/**
	 *原逻辑   用于更新时设置主键   已更新逻辑
	 * @return
	 */
	public int getMaxRoleId();
	/**
	 * 更新主键自增值      新逻辑
	 * @param value
	 */
	public void setPrimaryValue(int value);
	public List<Permission> queryPmsList(RoleQuery query);
	
	public int delete(RoleQuery query);
	/***
	 * 通过主键id 可选择性更新
	 * @param role
	 * @return 更新行数
	 */
	public int updateByPrimaryKeySelective(Role role);
}
