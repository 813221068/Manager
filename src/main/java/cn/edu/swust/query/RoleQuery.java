package cn.edu.swust.query;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class RoleQuery extends BaseQuery{

	private int roleId;
	
	private String roleName;
	
	private int[] roleIds;
	
	public boolean isNull() {
		if((roleId!=0)||roleName!=null||(roleIds!=null&&roleIds.length>0)) {
			return false;
		}
		return true;
	}
}
