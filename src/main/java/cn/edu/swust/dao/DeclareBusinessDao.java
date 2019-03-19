package cn.edu.swust.dao;

import java.util.List;

import cn.edu.swust.entity.DeclareBusiness;
import cn.edu.swust.query.DeclareBusinessQuery;

public interface DeclareBusinessDao {
	/***
	 * 查询用户申报项目表    多条
	 * @param query
	 * @return
	 */
	public List<DeclareBusiness> queryList(DeclareBusinessQuery query);
	
	public int count(DeclareBusinessQuery query);
	/***
	 * 删除用户申报项目
	 * @param query
	 * @return
	 */
	public int delete(DeclareBusinessQuery query);
	/**
	 * 可选择性插入单条
	 * @param declareBusiness
	 * @return  id
	 */
	public int insertOneSelective(DeclareBusiness declareBusiness);
	/**
	 * 查询单条
	 * @param query
	 * @return
	 */
	public DeclareBusiness query(DeclareBusinessQuery query);
	
	public int getMaxPrimaryKey();
	
	public void setPrimaryValue(int value);
}
