package cn.edu.swust.query;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class BaseQuery {

	/**
	 * 每页条数
	 */
	private int pageSize;
	
	/**
	 * 当前页
	 */
	private int currentPage;
	
	/**
	 * 用户权限 0 未登录 1 普通用户 2 管理员
	 */
//	private int role;
	
}
