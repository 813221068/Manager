package cn.edu.swust.entity.enumEntity;

public class UserRoleEnum {
	
	///旧逻辑 ： 固定用户角色         新逻辑：角色能够进行修改
	///管理员和用户角色不能够修改 
	///  todo 修改角色管理逻辑   deal:role表新增字段 标识能否改变
	
	public static final int UNLOGIN_USER = 0;
	/**
	 * 用户
	 */
	public static final int GENERAL_USER = 2;
	/**
	 * 管理员
	 */
	public static final int ADMIN_USER = 1;
}
