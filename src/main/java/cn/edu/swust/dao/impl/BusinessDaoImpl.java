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
			// TODO: handle exception
			LogHelper.logError(e.getMessage()+"\nsql为："+getNameSpace()+".queryList");
		}
		return list;
	}

	@Override
	public int getMaxBsnID() {
		try {
			return sqlSession.selectOne(getNameSpace()+".getMaxBsnID");
		} catch (Exception e) {
			// TODO: handle exception
			LogHelper.logError(e.getMessage()+"\nsql为："+getNameSpace()+".getMaxBsnID");
		}
		return 0;
	}

	@Override
	public int insertOneSelective(Business business) {
		int row = 0;
		try {
			row = sqlSession.insert(getNameSpace()+".insertOneSelective", business);
		} catch (Exception e) {
			// TODO: handle exception
			LogHelper.logError(e.getMessage()+"\nsql为："+getNameSpace()+"."+Thread.currentThread().getStackTrace()[1].getMethodName());
		}
		return row;
	}

	@Override
	public int delete(BusinessQuery query) {
		// TODO 自动生成的方法存根
		try {
			int row = sqlSession.delete(getNameSpace()+".delete", query);
			return row;
		} catch (Exception e) {
			LogHelper.logError(e.getMessage()+"\nsql为:"+getNameSpace()+".delete");
		}
		return 0;
	}

	@Override
	public int updateByPrimaryKeySelective(Business business) {
		int row = 0;
		try {
			row = sqlSession.update(getNameSpace()+".updateByPrimaryKeySelective", business);
		} catch (Exception e) {
			LogHelper.logError(e.getMessage()+"\nsql为:"+getNameSpace()+".updateByPrimaryKeySelective");
		}
		return row;
	}

}
