package cn.edu.swust.entity;

import org.eclipse.jdt.internal.compiler.ast.ThisReference;

import com.sun.org.apache.regexp.internal.recompile;

import lombok.Data;

@Data
public class Step {

	/**
	 * 审批流程id
	 */
	private int stepId;
	/***
	 * 流程名
	 */
	private String stepName;
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
	private String stepDesc;
	/**
	 * 审批的角色id
	 */
	private int approvalRoleId;
	
	
	public boolean equals(Object obj) {
		if(obj == this) {
			return true;
		}else {
			try {
				Step step = (Step) obj;
				if(step.getStepId()==stepId) {
					return true;
				}
			}catch (Exception e) {
				// TODO: handle exception
			}
			return false;
		}
	}
	
}
