package cn.edu.swust.dao;

import cn.edu.swust.query.DeclareDealQuery;

public interface DeclareDealDao {
	/***
	 * 删除申报项目对应流程
	 * @param query
	 * @return
	 */
	public int delete(DeclareDealQuery query);
}
