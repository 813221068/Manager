package cn.edu.swust.query;

import lombok.Data;

@Data
/**
 * 业务审批  查询流程类
 * @user:肖家林
 *
 * @time:下午9:15:44
 */
public class AprvStepQuery {
	/**
	 * 流程状态 0是等待  1是审批中   2是审批失败   3是审批通过
	 */
	private int status;
	/**
	 * 审批角色id
	 */
	private int approvalRoleId;
	/**
	 * 审批用户id
	 */
	private String approvalUserId;
}