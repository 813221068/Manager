package cn.edu.swust.entity;

import lombok.Data;

@Data
public class Deal {

	/**
	 * 审批流程id
	 */
	private int dealId;
	/***
	 * 流程名
	 */
	private String dealName;
	/**
	 * 对应项目id
	 */
	private int businessId;
	/**
	 * 审批的用户id
	 */
	private String approvalUserId;
	/**
	 * 优先级 由低到高 默认为0
	 */
	private int priority;
	/**
	 * 流程描述
	 */
	private String dealDesc;
	/**
	 * 审批的角色id
	 */
	private int approvalRoleId;
	
}
