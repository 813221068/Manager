package cn.edu.swust.entity;

import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;

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
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") 
	private Date createTime;
	/**
	 * 更新时间
	 */
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") 
	private Date updateTime;
	/**
	 * 创建人id
	 */
	private String createUserId;
	/**
	 * 状态     默认为1 ->草稿    2为->正式
	 */
	private int status;
	
	private String declareAsk;
	/**
	 * 是否可用  1表示可用   0表示删除
	 */
	private int isEnable;
	
	/*****************************/ //表外字段	
	private User createUser;
	
	private List<Step> steps;
	
	/****************************/
}
