package cn.edu.swust.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RolePermission {

	private int connId;
	
	private int roleId;
	
	private int permissionId;
}
