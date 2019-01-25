package cn.edu.swust.entity;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Permission {

	private int permissionId;
	
	private String permissionName;
	
	private String permissionDesc;
	
	/**
	 * 父菜单id  0为根菜单
	 */
	private int fatherId;
}
