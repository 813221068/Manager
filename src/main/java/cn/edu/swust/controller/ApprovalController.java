package cn.edu.swust.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;

import cn.edu.swust.RespEntity.AprvStepResp;
import cn.edu.swust.entity.Business;
import cn.edu.swust.entity.DeclareStep;
import cn.edu.swust.entity.User;
import cn.edu.swust.entity.enumEntity.PermissionEnum;
import cn.edu.swust.query.AprvStepQuery;
import cn.edu.swust.service.ApprovalService;
import cn.edu.swust.service.UserService;

@Controller
public class ApprovalController {
	
	@Autowired
	private ApprovalService approvalService;
	@Autowired
	private UserService userService;
	
	/** 跳转页 **/
	@RequestMapping("/approval")
	public String toApprovalPage(HttpSession session) {
		User user =  (User) session.getAttribute("user");
		boolean canGoRolePage = userService.isUserHasPms(user, PermissionEnum.APPROVAL);
		if(canGoRolePage) {
			return "approval";
		}
		else {
			session.setAttribute("pmsApprovalMark", true);
			return "index";
		}
	}
	
	/**接口**/
	@ResponseBody
	@RequestMapping(value="/getAprvSteps",method=RequestMethod.POST)
	public JSONArray getAprvSteps(@RequestBody AprvStepQuery query) {
		List<AprvStepResp> list = approvalService.getAprvStepResps(query);
		String json = JSONObject.toJSONString(list,SerializerFeature.DisableCircularReferenceDetect);
		JSONArray jsonArray = JSONArray.parseArray(json);
		
		return jsonArray;
	}
	
	@ResponseBody
	@RequestMapping(value="/doApproval",method=RequestMethod.POST)
	public boolean doApproval(@RequestBody DeclareStep declareStep) {
		return approvalService.doApproval(declareStep);
		
	} 
}