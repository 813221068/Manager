package cn.edu.swust.dao;

import java.util.List;

import cn.edu.swust.entity.RolePermission;
import cn.edu.swust.query.RolePermissionQuery;

public interface RolePermissionDao {

	public int insertOne(RolePermission rolePermission);
	
	public int getMaxId();
	
	public void setPrimaryValue(int value);
	
	public int delete(RolePermissionQuery query);
	
	public List<RolePermission> queryList(RolePermissionQuery query);
}
