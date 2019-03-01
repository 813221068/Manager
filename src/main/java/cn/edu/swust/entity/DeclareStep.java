package cn.edu.swust.entity;

import lombok.Data;

@Data
public class DeclareStep {
	/***
	 * 主键id
	 */
	private int connId;
	/***
	 * 申报项目id
	 */
	private int declareBusinessId;
	/***
	 * 流程id
	 */
	private int stepId;
	/**
	 * 状态  0是为开始  1是审批中   2是审批失败   3是审批通过
	 */
	private int status;
}
