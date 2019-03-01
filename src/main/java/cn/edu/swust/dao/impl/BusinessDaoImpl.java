package cn.edu.swust.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.edu.swust.dao.BusinessDao;
import cn.edu.swust.entity.Business;
import cn.edu.swust.query.BusinessQuery;
import cn.edu.swust.util.LogHelper;
@Repository
public class BusinessDaoImpl implements BusinessDao{
	@Autowired
	private SqlSession sqlSession;
	
	private String getNameSpace() {
		return "cn.edu.swust.mapper.BusinessMapper";
	}
	
	@Override
	public List<Business> queryList(BusinessQuery query) {
		List<Business> list = new ArrayList<>();
		try {
			list = sqlSession.selectList(getNameSpace()+".queryList", query);
		} catch (Exception e) {
			LogHelper.logError(e.getMessage()+"\nsql为："+getNameSpace()+".queryList");
		}
		return list;
	}

	@Override
	public void setPrimaryValue(int value) {
		sqlSession.selectOne(getNameSpace()+".setPrimaryValue",value);
	}

	@Override
	public int insertOneSelective(Business business) {
		int id = 0;
		if(sqlSession.insert(getNameSpace()+".insertOneSelective", business) != 0 ) {
			id = getMaxId();
		}
		return id;
	}

	@Override
	public int delete(BusinessQuery query) {
		return sqlSession.delete(getNameSpace()+".delete", query);
	}

	@Override
	public int updateByPrimaryKeySelective(Business business) {
		return sqlSession.update(getNameSpace()+".updateByPrimaryKeySelective", business);
	}

	@Override
	public int getMaxId() {
		return sqlSession.selectOne(getNameSpace()+".getMaxId");
	}

}
