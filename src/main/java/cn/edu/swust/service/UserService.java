package cn.edu.swust.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.edu.swust.dao.PermissionDao;
import cn.edu.swust.dao.UserDao;
import cn.edu.swust.dao.UserRoleDao;
import cn.edu.swust.entity.Permission;
import cn.edu.swust.entity.User;
import cn.edu.swust.entity.UserRole;
import cn.edu.swust.entity.enumEntity.UserRoleEnum;
import cn.edu.swust.query.PermissionQuery;
import cn.edu.swust.query.UserQuery;
import cn.edu.swust.query.UserRoleQuery;
import cn.edu.swust.util.ArrayUtil;
import cn.edu.swust.util.EncodeUtil;
import cn.edu.swust.util.LogHelper;
import cn.edu.swust.util.ObjectConvert;
import cn.edu.swust.util.StringUtil;
import net.sf.json.JSONArray;

@Service
public class UserService {

	@Autowired
    private UserDao userDao;
	@Autowired
	private UserRoleDao userRoleDao;
	@Autowired
	private PermissionDao pmsDao;
	
	public User queryUser(UserQuery query) {
		return userDao.query(query);
	}
	
	public UserRole queryUserRole(UserRoleQuery query) {
		return userRoleDao.query(query);
	}
	/**
	 * 登录
	 * @param userQuery
	 * @return
	 */
    public HashMap<String, Object> login(UserQuery userQuery) {
    	HashMap< String, Object> map = new HashMap<>();
    	try {
        	String psw = EncodeUtil.decode64Base(userQuery.getPassword());
        	userQuery.setPassword(EncodeUtil.encodeByMD5(psw));
        	User user = userDao.query(userQuery);
        	map.put("user",  userDao.query(userQuery));
        	
        	UserRoleQuery userRoleQuery = new UserRoleQuery();
        	userRoleQuery.setUserId(user.getUserId());
        	map.put("userRole",userRoleDao.query(userRoleQuery));
		} catch (Exception ex) {
			LogHelper.logError(ex);
		}

    	return map;
    }
    /**
     * 注册
     * @param user
     * @return
     */
    public boolean register(User user) {
    	UserQuery query = new UserQuery();
    	int ret = 0;
    	try {
    		query.setUsername(user.getUsername());
        	if(userDao.count(query)>0) {
        		return false;
        	}
        	user.setUserId(StringUtil.get32LengthString());
        	String psw = EncodeUtil.decode64Base(user.getPassword());
        	user.setPassword(EncodeUtil.encodeByMD5(psw));
        	int ret1 = userDao.insert(user);
        	//更新user_role
        	UserRole userRole = new UserRole();
        	userRole.setUserId(user.getUserId());
        	userRole.setRoleId(UserRoleEnum.GENERAL_USER);
        	int ret2 = userRoleDao.insert(userRole);
        	ret = ret1*ret2;
		} catch (Exception ex) {
			LogHelper.logError(ex);
		}
    	
    	return ret>0?true:false;
    }
    
    /**
	 * 查询权限  根据用户或者角色
	 * @param query
	 * @return
	 */
	public List<Permission> getPmsList(PermissionQuery query){
		List<Permission> list = new ArrayList<>();
		try {
			if(query.IsQueryByUser()) {
				
				list = pmsDao.queryPmsListByUser(query);
				
			}else if(query.IsQueryByRole()){
				
				list  = pmsDao.queryPmsListByRole(query);
				
			}else {
				
				list = pmsDao.queryList(query);
				
			}
		} catch (Exception e) {
			
			LogHelper.logError(e);
		}
		
		return list;
	}
	/***
	 * 查询用户
	 * @param query
	 * @return  用户list
	 */
	public List<User> getUserList(UserQuery query){
		List<User> users = new ArrayList<>();
		try {
			UserRoleQuery userRoleQuery = new UserRoleQuery();
			ObjectConvert.obj2Obj(query, userRoleQuery);
			//清除不在user表的查询条件
			query.setRoleId(0);
			query.setUserIds(userRoleDao.getUserIds(userRoleQuery));
			users = userDao.queryList(query);
		}catch (Exception e) {
			LogHelper.logError(e," getUserList");
		}
		return users;
	}
}
