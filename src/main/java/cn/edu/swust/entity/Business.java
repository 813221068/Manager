package cn.edu.swust.entity;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import com.alibaba.fastjson.annotation.JSONField;
import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
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
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss") 
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") 
	private Date createTime;
	/**
	 * 更新时间
	 */
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss") 
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
	/**
	 * 申报要求
	 */
	private MultipartFile file;
	
	private String fileName;
//	
	/*****************************/ //表外字段	
	private User createUser;
	
	private List<Step> steps;
	/**
	 * 当前用户是否申报该项目
	 */
	private boolean declare;
	
	/****************************/
}
