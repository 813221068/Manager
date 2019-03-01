package cn.edu.swust.query;

import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserQuery extends BaseQuery {
	
	private String userId;
	
	private String username;
	
	private String password;
	
	private List<String> userIds;
	
	/* 其他表的查询条件*/
	
	private int roleId;
}
