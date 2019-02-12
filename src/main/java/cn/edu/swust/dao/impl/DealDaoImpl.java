package cn.edu.swust.dao.impl;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.edu.swust.dao.DealDao;
import cn.edu.swust.entity.Deal;
import cn.edu.swust.query.DealQuery;
import cn.edu.swust.util.LogHelper;
@Repository
public class DealDaoImpl implements DealDao {
	@Autowired
	private SqlSession sqlSession;
	
	private String getNameSpace() {
		return "cn.edu.swust.mapper.DealMapper";
	}
	
	@Override
	public void setPrimaryValue(int value) {
		sqlSession.selectOne(getNameSpace()+".setPrimaryValue",value);
	}

	@Override
	public int insertOneSelective(Deal deal) {
		int row = 0;
		try {
			row = sqlSession.insert(getNameSpace()+".insertOneSelective", deal);
		} catch (Exception e) {
			throw e;
		}
		return row;
	}

	@Override
	public int batchInsert(List<Deal> list) {
		return  sqlSession.insert(getNameSpace()+".batchInsert", list);
	}

	@Override
	public int delete(DealQuery query) {
		return sqlSession.delete(getNameSpace()+".delete",query);
	}

	@Override
	public List<Deal> queryList(DealQuery query) {
		return sqlSession.selectList(getNameSpace()+".queryList", query);
	}

}
