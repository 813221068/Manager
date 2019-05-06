package cn.edu.swust.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;

import cn.edu.swust.ReqEntity.DownloadFileReq;
import cn.edu.swust.entity.Business;
import cn.edu.swust.entity.Step;
import cn.edu.swust.entity.User;
import cn.edu.swust.entity.enumEntity.PermissionEnum;
import cn.edu.swust.query.BusinessQuery;
import cn.edu.swust.service.BusinessService;
import cn.edu.swust.service.UserService;

@Controller
public class BusinessController {
	@Autowired
	private BusinessService businessService;
	@Autowired
	private UserService userService;
	/** 跳转页 **/
	@RequestMapping("/business")
	public String toLoginPage(HttpSession session) {
		User user =  (User) session.getAttribute("user");
		boolean canGoRolePage = userService.isUserHasPms(user, PermissionEnum.BUSINESS);
		if(canGoRolePage) {
			return "business";
		}
		else {
			session.setAttribute("pmsBusinessMark", true);
			return "index";
		}
//		return "business";
	}
	
	@RequestMapping("/declareBusiness")
	public String toDeclarePage() {
		return "declareBusiness";
	}
	
	@ResponseBody
	@RequestMapping(value="/businessList",method=RequestMethod.POST)
	public JSONArray getBusinessList(@RequestBody BusinessQuery query) {
		
		List<Business> list = businessService.getBusinessList(query);
		String json = JSONObject.toJSONString(list,SerializerFeature.DisableCircularReferenceDetect);
		JSONArray jsonArray = JSONArray.parseArray(json);
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
	public int addBusiness(@RequestBody Business business) {
//		System.out.println(business);
		return businessService.insertBusiness(business, business.getSteps());
	}
	/***
	 * 上传文件
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/uploadFile",method=RequestMethod.POST)
	public boolean uploadFile(MultipartFile file,Business bsns,HttpSession session) {
		boolean ret = false;
		//获取文件保存路径   ../WEB-INF/upload
		String savePath = session.getServletContext().getRealPath("/WEB-INF/upload");
//		System.out.println(bsns);
		if(file!=null) {
//			System.out.println(file.getOriginalFilename());
			ret = businessService.uploadFile(file, savePath,bsns);
		}
		
		return ret;
	}
	@ResponseBody
	@RequestMapping(value="/downloadFile",method=RequestMethod.POST,produces="application/octet-stream;charset=UTF-8")
	public ResponseEntity<byte[]> downloadFile(DownloadFileReq req,HttpSession session) throws IOException {
		//获取文件保存路径   ../WEB-INF/upload
		String filePath = session.getServletContext().getRealPath("/WEB-INF/"+req.getPath());
		File file = businessService.getFile(filePath, req);
		
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
		headers.setContentDispositionFormData("attachment",new String(req.getRealFileName().getBytes("UTF-8"), "ISO-8859-1"));
		
		return new ResponseEntity<byte[]>(FileUtils.readFileToByteArray(file),    
                headers, HttpStatus.CREATED); 
	}
	@ResponseBody
	@RequestMapping(value="/deleteBusiness")
	public int deleteBusiness(BusinessQuery query) {
		return businessService.delete(query);
	}
	
	@ResponseBody
	@RequestMapping(value="/batchDltBsns")
	public int batchDltBsns(BusinessQuery query) {
		return businessService.batchDelete(query.getBusinessIds());
	}
	
	@ResponseBody
	@RequestMapping(value="/updateBusiness",method=RequestMethod.POST)
	public boolean updateBusiness(@RequestBody Business business) {
//		System.out.println(business);
		return businessService.update(business,business.getSteps());
	}
}
