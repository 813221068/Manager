package cn.edu.swust.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.edu.swust.dao.RolePermissionDao;
import cn.edu.swust.entity.RolePermission;
import cn.edu.swust.query.RolePermissionQuery;
import cn.edu.swust.util.LogHelper;

@Repository
public class RolePermissionDaoImpl implements RolePermissionDao {

	@Autowired
	private SqlSession sqlSession;
	
	public String getNameSpace() {
		return "cn.edu.swust.mapper.RolePermissionMapper";
	}
	
	@Override
	public int insertOne(RolePermission rolePermission) {
		int ret = 0;
		try {
			ret = sqlSession.insert(getNameSpace()+".insertOne",rolePermission);
		} catch (Exception e) {
			LogHelper.logError(e.getMessage()+"\nsql为:"+getNameSpace()+".insertOne");
		}
		return ret;
	}

	@Override
	public int getMaxId() {
		int ret = 0;
		try {
			ret = sqlSession.selectOne(getNameSpace()+".getMaxId");
		} catch (Exception e) {
			LogHelper.logError(e.getMessage()+"\nsql为:"+getNameSpace()+".getMaxId");
		}
		return ret;
	}

	@Override
	public int delete(RolePermissionQuery query) {
		int row = sqlSession.delete(getNameSpace()+".delete", query);
		return row;
	}

	@Override
	public List<RolePermission> queryList(RolePermissionQuery query) {
		List<RolePermission> list = new ArrayList<>();
		list = sqlSession.selectList(getNameSpace()+".queryList",query);
		
		return list;
	}

	@Override
	public void setPrimaryValue(int value) {
		sqlSession.selectOne(getNameSpace()+".setPrimaryValue", value);
		
	}

}
