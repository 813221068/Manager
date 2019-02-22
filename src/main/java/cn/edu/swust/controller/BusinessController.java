package cn.edu.swust.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;

import cn.edu.swust.entity.Business;
import cn.edu.swust.entity.Deal;
import cn.edu.swust.query.BusinessQuery;
import cn.edu.swust.service.BusinessService;

@Controller
public class BusinessController {
	@Autowired
	private BusinessService businessService;

	/** 跳转页 **/
	@RequestMapping("/business")
	public String toLoginPage() {
		return "business";
	}
	
	@RequestMapping("/declareBusiness")
	public String toDeclarePage() {
		return "declareBusiness";
	}
	
	@ResponseBody
	@RequestMapping(value="/businessList")
	public JSONArray getBusinessList(BusinessQuery query) {
		List<Business> list = businessService.getBusinessList(query);
		JSONArray jsonArray = JSONArray.parseArray(JSON.toJSONString(list));
		return jsonArray;
	}
	/***
	 * 添加项目
	 * @param business
	 * @param deals
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/addBusiness",method=RequestMethod.POST)
	public int addBusiness(@RequestBody Business business,@RequestBody List<Deal> deals) {
		return businessService.insertBusiness(business, deals);
	}
	
	@ResponseBody
	@RequestMapping(value="/deleteBusiness")
	public int deleteBusiness(BusinessQuery query) {
		System.out.println(query);
		return businessService.delete(query);
	}
	
	@ResponseBody
	@RequestMapping(value="/updateBusiness")
	public int updateBusiness(@RequestBody Business business) {
//		return businessService.update(business);
		return 0;
	}
}
