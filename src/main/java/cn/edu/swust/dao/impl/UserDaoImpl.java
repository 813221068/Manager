package cn.edu.swust.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.edu.swust.dao.UserDao;
import cn.edu.swust.entity.Permission;
import cn.edu.swust.entity.User;
import cn.edu.swust.query.UserQuery;
import cn.edu.swust.util.LogHelper;

@Repository
public class UserDaoImpl implements UserDao{

	@Autowired
	private SqlSession sqlSession;
	
	public String getNameSpace() {
		return "cn.edu.swust.mapper.UserMapper";
	}

	@Override
	public User query(UserQuery query) {
		User res = null;
		try {
			res = sqlSession.selectOne(getNameSpace() + ".query", query);
		}
		catch (Exception ex) {
			LogHelper.logError(ex);
		}
		
		return res;
	}

	@Override
	public int count(UserQuery query) {
		int res = 0;
		try {
			res = sqlSession.selectOne(getNameSpace()+".count", query);
		} catch (Exception ex) {
			LogHelper.logError(ex);
		}
		
		return res;
	}

	@Override
	public int insert(User user) {
		int res = 0;
		try {
			res = sqlSession.insert(getNameSpace()+".insert", user);
		} catch (Exception ex) {
			LogHelper.logError(ex);
		}
		
		return res;
	}

	@Override
	public List<User> queryList(UserQuery query) {
		List<User> list = new ArrayList<>();
		try {
			list = sqlSession.selectList(getNameSpace()+".query", query);
		} catch (Exception e) {
			LogHelper.logError(e);
		}
		return list;
	}

	@Override
	public List<User> getUserListByRole(UserQuery query) {
		List<User> list = new ArrayList<>();
		try {
			list = sqlSession.selectList(getNameSpace()+".getUserListByRole", query);
		} catch (Exception e) {
			LogHelper.logError(e);
		}
		return list;
	}


}
