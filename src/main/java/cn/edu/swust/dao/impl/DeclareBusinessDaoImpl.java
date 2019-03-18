package cn.edu.swust.dao.impl;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.edu.swust.dao.DeclareBusinessDao;
import cn.edu.swust.entity.DeclareBusiness;
import cn.edu.swust.query.BusinessQuery;
import cn.edu.swust.query.DeclareBusinessQuery;
@Repository
public class DeclareBusinessDaoImpl implements DeclareBusinessDao {
	@Autowired
	private SqlSession sqlSession;
	
	private String getNameSpace() {
		return "cn.edu.swust.mapper.DeclareBusinessMapper";
	}
	@Override
	public List<DeclareBusiness> queryList(DeclareBusinessQuery query) {
		return sqlSession.selectList(getNameSpace()+".queryList", query);
	}
	@Override
	public int delete(DeclareBusinessQuery query) {
		return sqlSession.delete(getNameSpace()+".delete", query);
	}
	@Override
	public int count(DeclareBusinessQuery query) {
		return sqlSession.selectOne(getNameSpace()+".count",query);
	}
	@Override
	public int insertOneSelective(DeclareBusiness declareBusiness) {
		int id = 0;
		int row  = sqlSession.insert(getNameSpace()+"insertOneSelective", declareBusiness);
		if(row != 0) {
			id = getMaxPrimaryKey();
		}
		return id;
	}
	@Override
	public DeclareBusiness query(DeclareBusinessQuery query) {
		return sqlSession.selectOne(getNameSpace()+"query", query);
	}
	@Override
	public int getMaxPrimaryKey() {
		// TODO 自动生成的方法存根
		return sqlSession.selectOne(getNameSpace()+".getMaxPrimaryKey");
	}

}
