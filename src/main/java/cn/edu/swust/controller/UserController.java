package cn.edu.swust.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import javax.jws.soap.SOAPBinding;
import javax.management.Query;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.io.ResolverUtil.Test;
import org.apache.ibatis.reflection.wrapper.BaseWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;

import cn.edu.swust.entity.Permission;
import cn.edu.swust.entity.Role;
import cn.edu.swust.entity.User;
import cn.edu.swust.entity.UserRole;
import cn.edu.swust.entity.enumEntity.UserActiveEnum;
import cn.edu.swust.query.PermissionQuery;
import cn.edu.swust.query.UserQuery;
import cn.edu.swust.query.UserRoleQuery;
import cn.edu.swust.service.UserService;
import cn.edu.swust.util.EmailUtil;
import cn.edu.swust.util.EncodeUtil;
import cn.edu.swust.util.PropertiesUtil;
import sun.print.resources.serviceui;

@Controller
public class UserController {

	@Autowired
	UserService userService;
	
	/** 跳转页 **/
	@RequestMapping("/login")
	public String toLoginPage() {
		return "login";
	}
	
	
	@RequestMapping("/index")
	public String toIndexPage(HttpSession session) {
//		//测试代码 
		UserQuery query = new UserQuery();
		query.setUsername("admin");
//		
		User user = userService.queryUser(query);
		session.setAttribute("user", user);
		return "index";
	}
	
	@RequestMapping("/register")
	public String toRisterPage() {
		return "register";
	}
	
	
	/** 接口 **/
	/**
	 * 登录
	 * @param query
	 * @param attr
	 * @param session
	 * @return  0是用户名或密码错误   1是账号为激活    2是成功
	 */
	@ResponseBody
	@RequestMapping(value = "/login",method=RequestMethod.POST)
	public int login(UserQuery query,RedirectAttributes attr,HttpSession session) {
		int ret = 0;
		if(query.getPassword()!=null&&query.getPassword()!="") {
			String psw = EncodeUtil.decode64Base(query.getPassword());
			query.setPassword(EncodeUtil.encodeByMD5(psw));
		}
		
		User user = userService.queryUser(query);
		if(user==null) {
			ret =  0;
		}
		else if(user.getActive()==UserActiveEnum.inactivated) {
			ret =  1;
		}
		else {
			ret = 2;
			session.setAttribute("user", user);
		}
		
		return ret;
	}
	@ResponseBody
	@RequestMapping(value="/sendVerifyCode")
	public int sendVerifyCode(UserQuery query) {
		
		return userService.sendVerifyCode(query);
	}
	/**
	 * 用户注册    30分钟内邮箱未激活 则删除记录
	 * @param user
	 * @param attr
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/register",method=RequestMethod.POST)
	public int register(User user) {
		return userService.register(user);
	}
	@ResponseBody
	@RequestMapping(value="/nologin/activate")
	public String activate(User user) {
		String ret = "激活成功";
		if(!userService.activate(user)) {
			ret = "激活失败";
		}
		return ret;
	}
	/***
	 * 忘记密码  发送重置密码邮件
	 * @param query
	 */
	@ResponseBody
	@RequestMapping(value="/nologin/forgetPsw")
	public boolean forgetPsw(UserQuery query) {
		return userService.forgetPsw(query);
	}
	@ResponseBody
	@RequestMapping(value="/nologin/resetPsw")
	public String resetPsw(UserQuery query){
		String ret = "重置密码成功，默认密码为："+PropertiesUtil.getValue("defaultPassword");
		if(!userService.resetPsw(query)) {
			ret = "重置密码失败";
		}
		return ret;
	}
	@RequestMapping(value="/doLogout")
	public String logout(HttpSession session,RedirectAttributes attr) {
		//清除缓存
		session.invalidate();
		attr.addFlashAttribute("logout", true);
//		attr.addAttribute("logout", true);
		return "redirect:"+toLoginPage();
	}
	/***
	 * 根据角色或者用户 得到权限
	 * @param query
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/getPmsList",method=RequestMethod.POST)
	public JSONArray getPmsList(@RequestBody PermissionQuery query){
		List<Permission> list = userService.getPmsList(query);
		JSONArray jsonArray = JSONArray.parseArray(JSON.toJSONString(list));
		return jsonArray;
	}
	/***
	 * 查询用户
	 * @param query
	 * @return 用户list
	 */
	@ResponseBody
	@RequestMapping(value="/getUserList",method=RequestMethod.POST)
	public JSONArray getUserList(@RequestBody UserQuery query) {
		List<User> users = userService.getUserList(query);
		JSONArray jsonArray = JSONArray.parseArray(JSON.toJSONString(users));
		return jsonArray;
	}
}
