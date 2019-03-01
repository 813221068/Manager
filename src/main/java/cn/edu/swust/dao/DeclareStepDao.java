package cn.edu.swust.dao;

import cn.edu.swust.query.DeclareStepQuery;

public interface DeclareStepDao {
	/***
	 * 删除申报项目对应流程
	 * @param query
	 * @return
	 */
	public int delete(DeclareStepQuery query);
}
