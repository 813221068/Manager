package cn.edu.swust.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/declare")
public class DeclareController {

	/** 跳转页 **/
	@RequestMapping(value="")
	public String toDeclarePage() {
		return "declare/declare";
	}
	
	
	/** 接口  **/
	@RequestMapping(value="/uploadData")
	public void uploadData() {
		
	}
	
}
