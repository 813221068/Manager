package cn.edu.swust.util;

import java.util.Date;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import cn.edu.swust.entity.User;

public class EmailUtil {
	private static final String FROM = PropertiesUtil.getValue("mail.address");
	
	private static final String PASSWORD = PropertiesUtil.getValue("mail.password");
	
	private static final String PREFIX_URL = PropertiesUtil.getValue("project.host")+":"+PropertiesUtil.getValue("project.port")+
			"/"+PropertiesUtil.getValue("project.name");
	
	public static boolean sendResetPswEmail(String targetAddress,User user) {
		Session session = getSession();
		try {
			MimeMessage message = new MimeMessage(session);
			
			message.setSubject("重置密码邮件");
			message.setSentDate(new Date());
			message.setFrom(new InternetAddress(FROM));
			message.setRecipient(MimeMessage.RecipientType.TO, new InternetAddress(targetAddress));
			String url = PREFIX_URL+"/nologin/resetPsw"+"?userId="+user.getUserId();
			message.setContent("<p>复制链接到浏览器，重置密码</p><br><a target='_BLANK' href='"+url+"'>"+url+"</a>", 
					"text/html;charset=utf-8");
			
			Transport transport = session.getTransport();
			transport.connect(FROM, PASSWORD);
			transport.sendMessage(message, message.getAllRecipients());
			
			return true;
		} catch (Exception e) {
			// TODO: handle exception
			LogHelper.logError(e);
		}
		return false;
	}
	
	public static boolean sendAccountActiveEmail(String targetAddress,User user) {
		Session session = getSession();
		try {
			
			MimeMessage message = new MimeMessage(session);
			
			message.setSubject("请验证您的电子邮件地址");
			message.setSentDate(new Date());
			message.setFrom(new InternetAddress(FROM));
			message.setRecipient(MimeMessage.RecipientType.TO, new InternetAddress(targetAddress));
			String activeUrl = PREFIX_URL +"/nologin/activate"+"?userId="+user.getUserId();
			message.setContent("<p>复制链接到浏览器，激活账号</p><br><a target='_BLANK' href='"+activeUrl+"'>"+activeUrl+"</a>",
					"text/html;charset=utf-8");
			Transport transport = session.getTransport();
			transport.connect(FROM, PASSWORD);
			
			transport.sendMessage(message, message.getAllRecipients());
			
			return true;
		}catch (Exception e) {
			// TODO: handle exception
			LogHelper.logError(e);
		}
		return false;
	}
	
	private static Session getSession() {
		Properties props = new Properties();
		props.setProperty("mail.transport.protocol", PropertiesUtil.getValue("mail.transport.protocol"));
		props.setProperty("mail.smtp.host", PropertiesUtil.getValue("mail.smtp.host"));
		props.setProperty("mail.smtp.auth", PropertiesUtil.getValue("mail.smtp.auth"));
		props.setProperty("mail.smtp.port", PropertiesUtil.getValue("mail.smtp.port"));
		props.setProperty("mail.smtp.ssl.enable", PropertiesUtil.getValue("mail.smtp.ssl.enable"));
//		Session session = Sessions.getInstance(props, new Authenticator() {
//			@Override
//			protected PasswordAuthentication getPasswordAuthentication() {
//				return new PasswordAuthentication(FROM,PASSWORD);
//			}
//		});
		Session session = Session.getInstance(props);
		
//		session.setDebug(true);
		
		return session;
	}
	
	public static void main(String[] args) {
		System.out.println("开始发送邮件......");
		User user = new User();
		user.setUserId("5");
		boolean tmp = sendResetPswEmail("1770983566@qq.com",user);
		if(tmp) {
			System.out.println("邮件发送成功........");
		}else {
			System.out.println("邮件发送失败........");
		}
		
	}
}
