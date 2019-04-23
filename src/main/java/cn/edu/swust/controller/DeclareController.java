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
import javax.servlet.http.Part;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import cn.edu.swust.entity.DeclareBusiness;
import cn.edu.swust.query.DeclareBusinessQuery;
import cn.edu.swust.service.DeclareService;
import cn.edu.swust.util.PropertiesUtil;

@Controller
public class DeclareController {

	@Autowired
	private DeclareService declareService;
	
	/** 跳转页 **/
	@RequestMapping(value="/declare")
	public String toDeclarePage() {
		return "declare";
	}
	
	
	/** 接口  **/
	@ResponseBody
	@RequestMapping(value="/doDeclare",method=RequestMethod.POST)
	public boolean uploadData(MultipartFile[] files,DeclareBusiness declareBusiness) {
//		System.out.println(files);
		for (MultipartFile multipartFile : files) {
			System.out.println(multipartFile.getOriginalFilename());
		}
//		return declareService.uploadFile(files, declareBusiness);
		return false;
	} 
	
}
