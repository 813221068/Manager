package cn.edu.swust.dao.impl;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.edu.swust.dao.DeclareDealDao;
import cn.edu.swust.query.DeclareDealQuery;
@Repository
public class DeclareDealDaoImpl implements DeclareDealDao {
	@Autowired
	private SqlSession sqlSession;
	
	private String getNameSpace() {
		return "cn.edu.swust.mapper.DeclareDealMapper";
	}
	@Override
	public int delete(DeclareDealQuery query) {
		return sqlSession.delete(getNameSpace()+".delete",query);
	}

}
