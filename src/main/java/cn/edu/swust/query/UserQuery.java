package cn.edu.swust.query;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserQuery extends BaseQuery {
	
	private String userId;
	
	private String username;
	
	private String password;
	
	/*需要连表的字段*/
	
	private int roleId;
}
