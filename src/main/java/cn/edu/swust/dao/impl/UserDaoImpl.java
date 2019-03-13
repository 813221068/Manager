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
		
		return sqlSession.selectOne(getNameSpace() + ".query", query);
	}

	@Override
	public int count(UserQuery query) {
		
		return sqlSession.selectOne(getNameSpace()+".count", query);
	}

	@Override
	public int insert(User user) {
		
		return sqlSession.insert(getNameSpace()+".insert", user);
	}

	@Override
	public List<User> queryList(UserQuery query) {
		List<User> list = new ArrayList<>();
		list = sqlSession.selectList(getNameSpace()+".query", query);
		return list;
	}

	@Override
	public List<User> getUserListByRole(UserQuery query) {
		List<User> list = new ArrayList<>();
		list = sqlSession.selectList(getNameSpace()+".getUserListByRole", query);
		return list;
	}

	@Override
	public int delete(UserQuery query) {
		// TODO 自动生成的方法存根
		return sqlSession.delete(getNameSpace()+".delete", query);
	}

	@Override
	public int updateByPrimaryKeySelective(User user) {
		// TODO 自动生成的方法存根
		return sqlSession.update(getNameSpace()+".updateByPrimaryKeySelective", user);
	}


}
