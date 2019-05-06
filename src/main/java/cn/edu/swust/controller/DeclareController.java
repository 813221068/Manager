package cn.edu.swust.controller;

import java.io.File;
import java.io.IOException;
import java.text.MessageFormat;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.sun.org.apache.regexp.internal.recompile;

import cn.edu.swust.entity.Business;
import cn.edu.swust.entity.DeclareBusiness;
import cn.edu.swust.entity.Step;
import cn.edu.swust.entity.User;
import cn.edu.swust.entity.enumEntity.PermissionEnum;
import cn.edu.swust.query.BusinessQuery;
import cn.edu.swust.query.DeclareBusinessQuery;
import cn.edu.swust.service.DeclareService;
import cn.edu.swust.service.UserService;
import cn.edu.swust.util.PropertiesUtil;

@Controller
public class DeclareController {

	@Autowired
	private DeclareService declareService;
	@Autowired
	private UserService userService;
	
	/** 跳转页 **/
	@RequestMapping(value="/declare")
	public String toDeclarePage(HttpSession session) {
		User user =  (User) session.getAttribute("user");
		boolean canGoRolePage = userService.isUserHasPms(user, PermissionEnum.DECLARE);
		if(canGoRolePage) {
			return "declare";
		}
		else {
			session.setAttribute("pmsDeclareMark", true);
			return "index";
		}
	}
	
	
	/** 接口  **/
	@ResponseBody
	@RequestMapping(value="/doDeclare",method=RequestMethod.POST)
	public boolean uploadData(MultipartFile file,DeclareBusiness declareBusiness,HttpSession session) {
		declareBusiness.setDclFileName(file.getOriginalFilename());
		//获取文件保存路径   ../WEB-INF/declareFiles
		String savePath = session.getServletContext().getRealPath("/WEB-INF/declareFiles");
		return declareService.declareBsns(file, declareBusiness, savePath);
	}
	/**
	 * 申报页面 获取业务list
	 * @param query
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/getDclBsnsList",method=RequestMethod.POST)
	public JSONArray getDclBsnsList(@RequestBody BusinessQuery query) {
		List<Business> list = declareService.getBusinessList(query);
		String json = JSONObject.toJSONString(list,SerializerFeature.DisableCircularReferenceDetect);
		JSONArray jsonArray = JSONArray.parseArray(json);
		
		return jsonArray;
	}
	
	@ResponseBody
	@RequestMapping(value="/getDclSteps",method=RequestMethod.POST)
	public JSONArray getDclSteps(@RequestBody DeclareBusinessQuery query) {
		List<Step> list = declareService.getDclSteps(query);
		String json = JSONObject.toJSONString(list,SerializerFeature.DisableCircularReferenceDetect);
		JSONArray jsonArray = JSONArray.parseArray(json);
		
		return jsonArray;
	}
	
}
