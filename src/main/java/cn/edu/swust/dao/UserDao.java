package cn.edu.swust.dao;

import java.util.List;

import cn.edu.swust.entity.Permission;
import cn.edu.swust.entity.User;
import cn.edu.swust.query.UserQuery;

public interface UserDao{

	/**
	 * 查询单个
	 * @param query
	 * @return
	 */
	public User query(UserQuery query);
	/***
	 * 查询 list
	 * @param query
	 * @return
	 */
	public List<User> queryList(UserQuery query);
	
	/**
	 * 查询数量
	 * @param query
	 * @return
	 */
	public int count(UserQuery query);
	
	/**
	 * 增加    返回成功条数
	 * @param user
	 * @return
	 */
	public int insert(User user);
	/**
	 * 删除
	 * @return  影响行数
	 */
	public int delete(UserQuery query);
	
	
	public List<User> getUserListByRole(UserQuery query);
	
	public int updateByPrimaryKeySelective(User user);
	
	
}
