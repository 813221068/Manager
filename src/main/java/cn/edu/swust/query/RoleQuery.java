package cn.edu.swust.query;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;
/**
 * 角色查询类
 * @author xjl
 *
 */
@Data
@NoArgsConstructor
public class RoleQuery extends BaseQuery{
	
	private int roleId;
	
	private String roleName;
	
	private int[] roleIds;
	
	private Date updateTime;
	
}
