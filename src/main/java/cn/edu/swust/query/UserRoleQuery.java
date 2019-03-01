package cn.edu.swust.query;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserRoleQuery extends BaseQuery {

	private String userId;
	
	private int roleId;
}
