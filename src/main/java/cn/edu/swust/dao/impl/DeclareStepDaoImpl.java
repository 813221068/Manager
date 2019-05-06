package cn.edu.swust.dao.impl;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.edu.swust.dao.DeclareStepDao;
import cn.edu.swust.entity.DeclareStep;
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
	@Override
	public int insertOneSelective(DeclareStep declareStep) {
		// TODO 自动生成的方法存根
		return sqlSession.insert(getNameSpace()+".insertOneSelective", declareStep);
	}
	@Override
	public int insertBatch(List<DeclareStep> list) {
		// TODO 自动生成的方法存根
		setPrimaryValue(1);
		return sqlSession.insert(getNameSpace()+".insertBatch", list);
	}
	@Override
	public void setPrimaryValue(int value) {
		sqlSession.selectOne(getNameSpace()+".setPrimaryValue", value);
	}
	@Override
	public int updateByPrimaryKeySelective(DeclareStep declareStep) {
		return sqlSession.update(getNameSpace()+".updateByPrimaryKeySelective", declareStep);
	}
	@Override
	public List<DeclareStep> queryList(DeclareStepQuery query) {
		return sqlSession.selectList(getNameSpace()+".query", query);
	}

}
