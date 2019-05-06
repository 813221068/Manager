package cn.edu.swust.dao.impl;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.edu.swust.RespEntity.AprvStepResp;
import cn.edu.swust.dao.StepDao;
import cn.edu.swust.entity.Step;
import cn.edu.swust.query.AprvStepQuery;
import cn.edu.swust.query.DeclareBusinessQuery;
import cn.edu.swust.query.StepQuery;
import cn.edu.swust.util.LogHelper;
@Repository
public class StepDaoImpl implements StepDao {
	@Autowired
	private SqlSession sqlSession;
	
	private String getNameSpace() {
		return "cn.edu.swust.mapper.StepMapper";
	}
	
	@Override
	public void setPrimaryValue(int value) {
		sqlSession.selectOne(getNameSpace()+".setPrimaryValue",value);
	}

	@Override
	public int insertOneSelective(Step step) {
		int row = 0;
		try {
			row = sqlSession.insert(getNameSpace()+".insertOneSelective", step);
		} catch (Exception e) {
			throw e;
		}
		return row;
	}

	@Override
	public int batchInsert(List<Step> list) {
		return  sqlSession.insert(getNameSpace()+".batchInsert", list);
	}

	@Override
	public int delete(StepQuery query) {
		return sqlSession.delete(getNameSpace()+".delete",query);
	}

	@Override
	public List<Step> queryList(StepQuery query) {
		return sqlSession.selectList(getNameSpace()+".queryList", query);
	}

	@Override
	public int updateByPrimaryKeySelective(Step step) {
		return sqlSession.update(getNameSpace()+".updateByPrimaryKeySelective", step);
	}

	@Override
	public List<Step> queryDclSteps(DeclareBusinessQuery query) {
		return sqlSession.selectList(getNameSpace()+".queryDclSteps", query);
	}

	@Override
	public List<AprvStepResp> queryAprvStepResps(AprvStepQuery query) {
		return sqlSession.selectList(getNameSpace()+".queryAprvStepResps", query);
	}


}
