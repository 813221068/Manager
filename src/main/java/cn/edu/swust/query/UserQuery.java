package cn.edu.swust.query;

import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserQuery extends BaseQuery {
	
	private String userId;
	
	private String username;
	/**
	 * 邮箱     唯一
	 */
	private String mail;
	
	private int active;
	
	private String password;
	
	private String verifyCode;
	
	private List<String> userIds;
	
	/* 其他表的查询条件*/
	
	private int roleId;
}
