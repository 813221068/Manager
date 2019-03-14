package cn.edu.swust.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class DeclareController {

	/** 跳转页 **/
	@RequestMapping(value="/declare")
	public String toDeclarePage() {
		return "declare";
	}
	
	
	/** 接口  **/
	@RequestMapping(value="/doDeclare")
	public void uploadData() {
		
	}
	
}
