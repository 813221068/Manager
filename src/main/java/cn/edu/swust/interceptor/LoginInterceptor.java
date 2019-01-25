package cn.edu.swust.interceptor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import cn.edu.swust.controller.UserController;
import cn.edu.swust.entity.User;
import cn.edu.swust.util.PropertiesUtil;
import lombok.Data;

@Data
public class LoginInterceptor implements HandlerInterceptor{
	
	private List<String> exceptUrls;
	
	@Autowired
	UserController userController;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		//debug 正式删掉
		if(PropertiesUtil.getValue("debug").equals("true")) {
			return true;
		}
		
		String reqUrl = request.getRequestURL().toString();
		for(String url : exceptUrls) {
			//todo /loginaaa 也能通过
			if(reqUrl.indexOf(url)>=0) {
				return true;
			}
		}
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("user");
		if(user != null) {
			return true;
		}
		//转发
		request.setAttribute("msg", "还没有登录");
		request.getRequestDispatcher(userController.toLoginPage()).forward(request, response);
		//重定向
//		response.sendRedirect(userController.toLoginPage());
		return false;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		// TODO 自动生成的方法存根
		
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		// TODO 自动生成的方法存根
		
	}

}
