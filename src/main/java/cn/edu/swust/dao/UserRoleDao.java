package cn.edu.swust.dao;

import java.util.List;

import cn.edu.swust.entity.UserRole;
import cn.edu.swust.query.UserRoleQuery;

public interface UserRoleDao {

	public int insert(UserRole userRole);
	
	public UserRole query(UserRoleQuery query);
	
	public List<UserRole> queryList(UserRoleQuery query);
}
