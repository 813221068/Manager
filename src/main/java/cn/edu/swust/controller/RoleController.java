package cn.edu.swust.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

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

import cn.edu.swust.entity.Role;
import cn.edu.swust.query.RoleQuery;
import cn.edu.swust.service.RoleService;

@Controller
public class RoleController {

	@Autowired
	private RoleService roleService;
	
	@RequestMapping(value="/role")
	public String toIndexPage() {
		return "role";
	}
	
	@ResponseBody
	@RequestMapping(value="/getRoleList",method=RequestMethod.GET)
	public JSONArray getRoleList(RoleQuery query) {
		List<Role> list = roleService.queryList(query);
		JSONArray array= JSONArray.parseArray(JSON.toJSONString(list));
		return array;
	}

	@ResponseBody
	@RequestMapping(value="/addRole")
	public int add(@RequestBody Role role) {
		int ret = roleService.addRole(role);
		return ret;
	}
	
	@ResponseBody
	@RequestMapping(value="/deleteRole")
	public int delete( RoleQuery query) {
//		System.out.println(query);
		return roleService.delete(query);
	}
	
	@ResponseBody
	@RequestMapping(value="/updateRole")
	public int update(@RequestBody Role role){
		return roleService.updateRole(role);
	}
	
	
}
