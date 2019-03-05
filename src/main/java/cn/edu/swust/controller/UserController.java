package cn.edu.swust.controller;

import java.util.HashMap;
import java.util.List;

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
import cn.edu.swust.query.PermissionQuery;
import cn.edu.swust.query.UserQuery;
import cn.edu.swust.query.UserRoleQuery;
import cn.edu.swust.service.UserService;

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
	@RequestMapping(value = "/login",method=RequestMethod.POST)
	public String login(UserQuery query,RedirectAttributes attr,HttpSession session) {
		HashMap<String, Object> map = userService.login(query);
		User user = (User) map.get("user");
		UserRole userRole = (UserRole)map.get("userRole");
		if(user != null) {
			attr.addFlashAttribute("msg", "success");
			session.setAttribute("user", user);
			session.setAttribute("userRole", userRole);
			//所有权限
			session.setAttribute("pmsAll", getPmsList(new PermissionQuery()));
			
			return "redirect:"+toIndexPage(session);
		}
		attr.addFlashAttribute("msg", "用户名或密码错误");
		return "redirect:"+toLoginPage();
	}
	
	@RequestMapping(value="/register",method=RequestMethod.POST)
	public String register(User user,RedirectAttributes attr) {
		String msg = "注册成功,请登录";
		if(!userService.register(user)) {
			msg = "注册失败，用户名已存在";
			attr.addFlashAttribute("msg", msg);
			return "redirect:"+toRisterPage();
		}
		attr.addFlashAttribute("msg", msg);
		return "redirect:"+toLoginPage();
	}
	
	@RequestMapping(value="/doLogout")
	public String logout(HttpSession session,RedirectAttributes attr) {
		String msg = "登出成功";
		//清除缓存
		session.invalidate();
		attr.addFlashAttribute("msg", msg);
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
