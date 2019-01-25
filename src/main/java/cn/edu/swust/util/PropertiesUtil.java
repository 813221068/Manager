package cn.edu.swust.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class PropertiesUtil {
	public static String getValue(String key){
		Properties prop = new Properties();
		InputStream is = new PropertiesUtil().getClass().getResourceAsStream("/config.properties");
		try {
			prop.load(is);
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		//返回获取的值
		return prop.getProperty(key);
	}
	public static void main(String[] args) {
		String string = getValue("debug");
		if(string.equals("true")) {
			System.out.println("debug");
		}
		System.out.println(string);
	}
}
