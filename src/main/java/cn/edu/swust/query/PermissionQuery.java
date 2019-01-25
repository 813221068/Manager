package cn.edu.swust.query;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class PermissionQuery extends BaseQuery{
	//按角色查询
	private int roleId;
	
	private String roleName;
	
	//按用户查询
	private String userId;
	
	private String username;
	
	public boolean IsQueryByUser() {
		if(userId!=null||username!=null) {
			return true;
		}
		return false;
	}
	
	public boolean IsQueryByRole() {
		if(roleId != 0 || roleName!=null) {
			return true;
		}
		return false;
	}
	
	private String order;
}
