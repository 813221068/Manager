package cn.edu.swust.dao.impl;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.edu.swust.dao.DeclareStepDao;
import cn.edu.swust.query.DeclareStepQuery;
@Repository
public class DeclareStepDaoImpl implements DeclareStepDao {
	@Autowired
	private SqlSession sqlSession;
	
	private String getNameSpace() {
		return "cn.edu.swust.mapper.DeclareStepMapper";
	}
	@Override
	public int delete(DeclareStepQuery query) {
		return sqlSession.delete(getNameSpace()+".delete",query);
	}

}
