package cn.edu.swust.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.edu.swust.dao.RoleDao;
import cn.edu.swust.dao.UserDao;
import cn.edu.swust.entity.Permission;
import cn.edu.swust.entity.Role;
import cn.edu.swust.query.RoleQuery;
import cn.edu.swust.util.LogHelper;
@Repository
public class RoleDaoImpl implements RoleDao {
	@Autowired
	private SqlSession sqlSession;
	
	public String getNameSpace() {
		return "cn.edu.swust.mapper.RoleMapper";
	}
	
	@Override
	public List<Role> queryList(RoleQuery query) {
		List<Role> list = new ArrayList<>();
		try {
			list  = sqlSession.selectList(getNameSpace()+".queryList", query);
		} catch (Exception e) {
			LogHelper.logError(e.getMessage()+"\nsql为:"+getNameSpace()+".queryList");
		}
		return list;
	}

	@Override
	public int insertOne(Role role) {
		int id = 0;
		int row = sqlSession.insert(getNameSpace()+".insertOne", role);
		
		if(row != 0) {
			id = getMaxRoleId();
		}
		
		return id;
	}

	@Override
	public List<Permission> queryPmsList(RoleQuery query) {
		List<Permission> list = new ArrayList<>();
		try {
			list = sqlSession.selectList(getNameSpace()+".queryPmsList",query);
		} catch (Exception e) {
			LogHelper.logError(e.getMessage()+"\nsql为:"+getNameSpace()+".queryPmsList");
			
		}
		return list;
	}

	@Override
	public int getMaxRoleId() {
		int maxId = 0;
		try {
			maxId = sqlSession.selectOne(getNameSpace()+".getMaxRoleId");
		} catch (Exception e) {
			LogHelper.logError(e.getMessage()+"\nsql为:"+getNameSpace()+".getMaxRoleId");
		}
		return maxId;
	}

	@Override
	public int delete(RoleQuery query) {
		return sqlSession.delete(getNameSpace()+".delete", query);
	}

	@Override
	public int updateByPrimaryKeySelective(Role role) {
		int row = 0;
		try {
			row = sqlSession.update(getNameSpace()+".updateByPrimaryKeySelective", role);
		} catch (Exception e) {
			LogHelper.logError(e.getMessage()+"\nsql为:"+getNameSpace()+".updateByPrimaryKeySelective");
		}
		return row;
	}

	@Override
	public void setPrimaryValue(int value) {
		sqlSession.selectOne(getNameSpace()+".setPrimaryValue", value);
	}

}
