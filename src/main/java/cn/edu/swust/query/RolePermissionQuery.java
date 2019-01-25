package cn.edu.swust.query;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class RolePermissionQuery {

	private int roleId;
	
	private int permissionId;
}
