package cn.edu.swust.entity;

import java.util.Date;
import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Business {
	/**
	 * 业务id
	 */
	private int businessId;
	/***
	 * 业务名
	 */
	private String businessName;
	/**
	 * 业务描述
	 */
	private String businessDesc;
	/**
	 * 创建时间
	 */
	private Date createTime;
	/**
	 * 更新时间
	 */
	private Date updateTime;
	/**
	 * 创建人id
	 */
	private String createUserId;
	
	/*****************************/ //表外字段	
	private User createUser;
	
	/****************************/
}
