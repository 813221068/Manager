package cn.edu.swust.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.edu.swust.dao.UserRoleDao;
import cn.edu.swust.entity.User;
import cn.edu.swust.entity.UserRole;
import cn.edu.swust.query.UserRoleQuery;
import cn.edu.swust.util.LogHelper;
@Repository
public class UserRoleDaoImpl implements UserRoleDao {
	@Autowired
	private SqlSession sqlSession;
	
	public String getNameSpace() {
		return "cn.edu.swust.mapper.UserRoleMapper";
	}

	@Override
	public int insert(UserRole userRole) {
		
		return sqlSession.insert(getNameSpace()+".insert", userRole);
	}

	@Override
	public UserRole query(UserRoleQuery query) {
		
		return sqlSession.selectOne(getNameSpace() + ".query", query);
	}

	@Override
	public List<UserRole> queryList(UserRoleQuery query) {
		List<UserRole> list = new ArrayList<>();
		list = sqlSession.selectList(getNameSpace()+".query", query);
		
		return list;
	}

	@Override
	public List<String> getUserIds(UserRoleQuery query) {
		List<String> userIds = new ArrayList<>();
		userIds = sqlSession.selectList(getNameSpace()+".getUserIds", query);
		return userIds;
	}
}
