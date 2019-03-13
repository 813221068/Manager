package cn.edu.swust.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import cn.edu.swust.dao.PermissionDao;
import cn.edu.swust.dao.UserDao;
import cn.edu.swust.dao.UserRoleDao;
import cn.edu.swust.entity.Permission;
import cn.edu.swust.entity.User;
import cn.edu.swust.entity.UserRole;
import cn.edu.swust.entity.enumEntity.UserActiveEnum;
import cn.edu.swust.entity.enumEntity.UserRoleEnum;
import cn.edu.swust.query.PermissionQuery;
import cn.edu.swust.query.UserQuery;
import cn.edu.swust.query.UserRoleQuery;
import cn.edu.swust.util.ArrayUtil;
import cn.edu.swust.util.EmailUtil;
import cn.edu.swust.util.EncodeUtil;
import cn.edu.swust.util.LogHelper;
import cn.edu.swust.util.ObjectConvert;
import cn.edu.swust.util.PropertiesUtil;
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
	
	private static final String DEFAULT_PSW = PropertiesUtil.getValue("defaultPassword");
	
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
//    	
//    	try {
//        	String psw = EncodeUtil.decode64Base(userQuery.getPassword());
//        	userQuery.setPassword(EncodeUtil.encodeByMD5(psw));
//        	User user = userDao.query(userQuery);
//        	map.put("user",  userDao.query(userQuery));
//        	
//        	UserRoleQuery userRoleQuery = new UserRoleQuery();
//        	userRoleQuery.setUserId(user.getUserId());
//        	map.put("userRole",userRoleDao.query(userRoleQuery));
//		} catch (Exception ex) {
//			LogHelper.logError(ex);
//		}
    	HashMap< String, Object> map = new HashMap<>();
    	try {
    		String psw = EncodeUtil.decode64Base(userQuery.getPassword());
    		userQuery.setPassword(EncodeUtil.encodeByMD5(psw));
    		
    		User user = userDao.query(userQuery);
    		if(user != null) {
    			map.put("user",  userDao.query(userQuery));
    			
    			UserRoleQuery userRoleQuery = new UserRoleQuery();
            	userRoleQuery.setUserId(user.getUserId());
            	map.put("userRole",userRoleDao.query(userRoleQuery));
    		}
    	}
		catch (Exception e) {
			LogHelper.logError(e);
		}
    	return map;
    }
    /**
     * 忘记密码   发送邮件
     * @param query
     * @return
     */
    public boolean forgetPsw(UserQuery query) {
    	boolean ret = false;
    	try {
    		User user = userDao.query(query);
    		if(user.getActive() == 1) {
    			ret = EmailUtil.sendResetPswEmail(query.getMail(), user);
    		}
		} catch (Exception e) {
			// TODO: handle exception
			ret = false;
			LogHelper.logError(e);
		}
    	return ret;
    }
    
    public boolean resetPsw(UserQuery query) {
    	int ret = 0;
    	try {
			if(query.getUserId()!=null) {
				User user = new User();
				user.setUserId(query.getUserId());
				user.setPassword(EncodeUtil.encodeByMD5(DEFAULT_PSW));
				
				ret = userDao.updateByPrimaryKeySelective(user);
			}
		} catch (Exception e) {
			// TODO: handle exception
			LogHelper.logError(e);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ret = 0;
		}
    	return ret==0?false:true;
    }
    /**
     * 注册
     * @param user
     * @return 0是发生异常或错误  1是用户名重复  2是邮箱重复  3是成功
     */
    public int register(User user) {
    	int ret = addRegister(user);
    	if(ret!=3) {
    		return ret;
    	}
    	
    	Timer timer = new Timer();
    	//有效期 ?min
		int activeTime = 30;
		
		timer.schedule(new TimerTask() {
			@Override
			public void run() {
				// TODO 自动生成的方法存根
				UserQuery query = new UserQuery();
				query.setMail(user.getMail());
				User rgstUser = userDao.query(query);
				if(rgstUser.getActive() == 0) {
					userDao.delete(query);
					
					UserRoleQuery userRoleQuery = new UserRoleQuery();
					userRoleQuery.setUserId(rgstUser.getUserId());
					
					userRoleDao.delete(userRoleQuery);
					
					LogHelper.logInfo("链接已失效");
				}
			}
		}, activeTime*1000*60);
		if(!EmailUtil.sendAccountActiveEmail(user.getMail(), user)) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			timer.cancel();
			ret = 0;
		}
    	
    	return ret;
    }
    
    public boolean activate(User user) {
    	user.setActive(UserActiveEnum.activated);
    	int row = userDao.updateByPrimaryKeySelective(user);
    	return row==0?false:true;
    }
    /**
     * 注册用户  插入数据
     * @param user
     * @return 0是发生异常或错误  1是用户名重复  2是邮箱重复  3是成功
     */
    private int addRegister(User user) {
    	UserQuery query = new UserQuery();
    	
    	int ret = 0;
    	try {
    		query.setUsername(user.getUsername());
    		if(userDao.count(query)>0) {
    			return 1;
    		}
    		
    		query = new UserQuery();
    		query.setMail(user.getMail());
        	if(userDao.count(query)>0) {
        		return 2;
        	}
        	
        	user.setUserId(StringUtil.get32LengthString());
        	//前端psw 采用64base加密
        	String psw = EncodeUtil.decode64Base(user.getPassword());
        	user.setPassword(EncodeUtil.encodeByMD5(psw));
        	user.setActive(UserActiveEnum.inactivated);
        	
        	int ret1 = userDao.insert(user);
        	//更新user_role
        	UserRole userRole = new UserRole();
        	userRole.setUserId(user.getUserId());
        	userRole.setRoleId(UserRoleEnum.GENERAL_USER);
        	int ret2 = userRoleDao.insert(userRole);
        	
        	ret = ret1*ret2;
		} catch (Exception ex) {
			LogHelper.logError(ex);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ret = 0;
		}
    	
    	return ret>0?3:0;
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
