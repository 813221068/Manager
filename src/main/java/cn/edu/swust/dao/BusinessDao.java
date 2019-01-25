package cn.edu.swust.dao;

import java.util.List;

import cn.edu.swust.entity.Business;
import cn.edu.swust.query.BusinessQuery;

public interface BusinessDao {

	public List<Business> queryList(BusinessQuery query);
	
	public int getMaxBsnID();
	/**
	 * 可选择性插入单条 
	 * @param business
	 * @return 插入行数
	 */
	public int insertOneSelective(Business business);
	
	public int delete(BusinessQuery query);
	/**
	 * 可选择性更新
	 * @param business
	 * @return 影响行数
	 */
	public int updateByPrimaryKeySelective(Business business);
}
