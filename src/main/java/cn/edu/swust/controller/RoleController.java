package cn.edu.swust.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;

import cn.edu.swust.entity.Permission;
import cn.edu.swust.entity.Role;
import cn.edu.swust.entity.User;
import cn.edu.swust.entity.enumEntity.PermissionEnum;
import cn.edu.swust.query.RoleQuery;
import cn.edu.swust.service.RoleService;
import cn.edu.swust.service.UserService;

@Controller
public class RoleController {

	@Autowired
	private RoleService roleService;
	@Autowired
	private UserService userService;
	
	@RequestMapping(value="/role")
	public String toIndexPage(HttpSession session) {
		User user =  (User) session.getAttribute("user");
		boolean canGoRolePage = userService.isUserHasPms(user, PermissionEnum.ROLE);
		if(canGoRolePage) {
			return "role";
		}
		else {
			session.setAttribute("pmsRoleMark", 2);
			return "index";
		}
	}
	
	@ResponseBody
	@RequestMapping(value="/getRoleList",method=RequestMethod.POST)
	public JSONArray getRoleList(@RequestBody RoleQuery query) {
		List<Role> list = roleService.queryList(query);
		//消除循环引用
		String json = JSONObject.toJSONString(list,SerializerFeature.WriteMapNullValue
				,SerializerFeature.DisableCircularReferenceDetect);
		JSONArray array= JSONArray.parseArray(json);
		return array;
	}

	@ResponseBody
	@RequestMapping(value="/addRole",method=RequestMethod.POST)
	public int add(@RequestBody Role role) {
		int id = roleService.addRole(role);
		return id;
	}
	
	@ResponseBody
	@RequestMapping(value="/deleteRole")
	public int delete( RoleQuery query) {
//		System.out.println(query);
		return roleService.delete(query);
	}
	
	@ResponseBody
	@RequestMapping(value="/updateRole",method=RequestMethod.POST)
	public int update( @RequestBody Map<String,Object> map){
		Role role  = JSON.parseObject(JSON.toJSONString(map.get("role")),Role.class);
		List<Permission> addPmsList = JSONArray.parseArray(JSON.toJSONString(map.get("addPmsList")),
				Permission.class);
		return roleService.updateRole(role,addPmsList);
	}
	
	
}
