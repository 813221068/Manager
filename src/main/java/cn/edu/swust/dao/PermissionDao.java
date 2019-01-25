package cn.edu.swust.dao;

import java.util.List;

import cn.edu.swust.entity.Permission;
import cn.edu.swust.query.PermissionQuery;

public interface PermissionDao {

	public List<Permission> queryPmsListByRole(PermissionQuery query);
	
	public List<Permission> queryPmsListByUser(PermissionQuery query);
	
	public List<Permission> queryList(PermissionQuery query);
}
