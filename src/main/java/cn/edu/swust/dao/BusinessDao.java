package cn.edu.swust.dao;

import java.util.List;

import cn.edu.swust.entity.Business;
import cn.edu.swust.query.BusinessQuery;

public interface BusinessDao {

	public List<Business> queryList(BusinessQuery query);
	
	public void setPrimaryValue(int value);
	/**
	 * 可选择性插入单条 
	 * @param business
	 * @return id  插入失败为0 
	 *
	 */
	public int insertOneSelective(Business business);
	/***
	 *根据businessId删除   isenable=0  且更新updateTime
	 * @param business
	 * @return row
	 */
	public int deleteById(Business business);
	/**
	 * 可选择性更新
	 * @param business
	 * @return 影响行数
	 */
	public int updateByPrimaryKeySelective(Business business);
	/**
	 * 获取id最大值
	 * @return
	 */
	public int getMaxId();
}
