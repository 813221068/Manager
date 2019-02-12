package cn.edu.swust.dao;

import java.util.List;

import cn.edu.swust.entity.Deal;
import cn.edu.swust.query.DealQuery;

public interface DealDao {

	/***
	 * 设置主键自增值
	 * @return
	 */
	public void setPrimaryValue(int value);
	/***
	 * 可选择性的单条插入
	 * @param deal
	 * @return
	 */
	public int insertOneSelective(Deal deal);
	/***
	 * 批零插入
	 * @param list
	 * @return
	 */
	public int batchInsert(List<Deal> list);
	/***
	 * 删除 deal
	 * @param query
	 * @return
	 */
	public int delete(DealQuery query);
	/***
	 * 查询多个记录
	 * @param query
	 * @return
	 */
	public List<Deal> queryList(DealQuery query);
}
