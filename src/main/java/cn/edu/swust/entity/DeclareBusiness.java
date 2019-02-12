package cn.edu.swust.entity;

import java.util.Date;

import lombok.Data;

@Data
public class DeclareBusiness {

	/***
	 * 主键id
	 */
	private int connId;
	/***
	 * 项目id
	 */
	private int businessId;
	/***
	 * 申报人id
	 */
	private String  declareUserId;
	/***
	 * 开始时间
	 */
	private Date startTime;
	/**
	 * 申报状态  0是没有开始 1是进行中  2是申报失败 3是申报完成
	 */
	private int status;
}
