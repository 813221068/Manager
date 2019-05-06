package cn.edu.swust.dao;

import java.util.List;

import cn.edu.swust.RespEntity.AprvStepResp;
import cn.edu.swust.entity.Step;
import cn.edu.swust.query.AprvStepQuery;
import cn.edu.swust.query.DeclareBusinessQuery;
import cn.edu.swust.query.StepQuery;


public interface StepDao {

	/***
	 * 设置主键自增值
	 * @return
	 */
	public void setPrimaryValue(int value);
	/***
	 * 可选择性的单条插入
	 * @param step
	 * @return
	 */
	public int insertOneSelective(Step step);
	/***
	 * 批零插入
	 * @param list
	 * @return
	 */
	public int batchInsert(List<Step> list);
	/***
	 * 删除 step
	 * @param query
	 * @return
	 */
	public int delete(StepQuery query);
	/***
	 * 查询多个记录
	 * @param query
	 * @return
	 */
	public List<Step> queryList(StepQuery query);
	
	public int updateByPrimaryKeySelective(Step step);
	/**
	 * 查询 用户申报业务的申报流程
	 * @param query
	 * @return
	 */
	public List<Step> queryDclSteps(DeclareBusinessQuery query);
	/***
	 * 业务审批    审批流程
	 * @param query
	 * @return
	 */
	public List<AprvStepResp> queryAprvStepResps(AprvStepQuery query);
}
