package cn.edu.swust.entity;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.alibaba.fastjson.annotation.JSONField;
import com.fasterxml.jackson.annotation.JsonFormat;

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
//	@JSONField(format = "yyyy-MM-dd HH:mm:ss")
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss") 
	private Date startTime;
//	private String startTime;
	/***
	 * 结束时间
	 */
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") 
	private Date endTime;
	/**
	 * 申报状态   1是进行中  2是申报失败 3是申报完成
	 */
	private int status;
}
