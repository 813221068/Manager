package cn.edu.swust.dao;

import java.util.List;

import cn.edu.swust.entity.DeclareStep;
import cn.edu.swust.query.DeclareStepQuery;

public interface DeclareStepDao {
	/***
	 * 删除申报项目对应流程
	 * @param query
	 * @return
	 */
	public int delete(DeclareStepQuery query);
	/**
	 * 
	 * @param declareStep
	 * @return row
	 */
	public int insertOneSelective(DeclareStep declareStep);
	
	public int insertBatch(List<DeclareStep> list);
	
	public void setPrimaryValue(int value);
}
