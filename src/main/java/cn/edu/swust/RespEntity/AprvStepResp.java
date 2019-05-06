package cn.edu.swust.RespEntity;

import cn.edu.swust.entity.Business;
import cn.edu.swust.entity.User;
import lombok.Data;

@Data
/***
 * 业务审批   审批流程类
 * @user:肖家林
 *
 * @time:下午11:33:57
 */
public class AprvStepResp {
	/**
	 * declare_step 主键
	 */
	private int connId;
	/**
	 * declare_business 主键
	 */
	private int declareBusinessId;

	private int stepId;
	
	private String stepName;
	
	private int businessId;
	
	private String declareUserId;
	
	private String dclFileName;
	
	private User declareUser;
	
	private Business business;
	
}