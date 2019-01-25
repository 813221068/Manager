package cn.edu.swust.entity;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserRole {

	private int connId;
	
	private String userId;
	
	private int roleId;
}
