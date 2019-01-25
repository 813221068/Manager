package cn.edu.swust.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.edu.swust.dao.PermissionDao;
import cn.edu.swust.entity.Permission;
import cn.edu.swust.query.PermissionQuery;
import cn.edu.swust.util.LogHelper;

@Repository
public class PermissionDaoImpl implements PermissionDao {

	@Autowired
	private SqlSession sqlSession;
	
	private String getNameSpace() {
		return "cn.edu.swust.mapper.PermissionMapper";
	}
	
	@Override
	public List<Permission> queryPmsListByRole(PermissionQuery query) {
		List<Permission> list = new ArrayList<>();
		try {
			list = sqlSession.selectList(getNameSpace()+".queryPmsListByRole",query);
		} catch (Exception e) {
			LogHelper.logError(e);
		}
		return list;
	}

	@Override
	public List<Permission> queryPmsListByUser(PermissionQuery query) {
		List<Permission> list = new ArrayList<>();
		try {
			list = sqlSession.selectList(getNameSpace()+".queryPmsListByUser",query);
		} catch (Exception e) {
			LogHelper.logError(e);
		}
		return list;
	}

	@Override
	public List<Permission> queryList(PermissionQuery query) {
		List<Permission> list = new ArrayList<>();
		try {
			list = sqlSession.selectList(getNameSpace()+".queryList",query);
		} catch (Exception e) {
			LogHelper.logError(e.getMessage()+"\nsql为:"+getNameSpace()+".queryList");
		}
		return list;
	}

}
