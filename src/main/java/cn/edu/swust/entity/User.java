package cn.edu.swust.entity;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class User {

	private String userId;
	
	private String username;
	
	private String password;
	
	private String mail;
	/**
	 * 激活状态    1是未激活    2是激活
	 */
	private int active;
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") 
	private Date createTime;
	
}
