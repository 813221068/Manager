package cn.edu.swust.util;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.UUID;

public class StringUtil {

	/**
	 * 生成32位随机字符串 不重复
	 * @return
	 */
	public static String get32LengthString() {
		UUID uuid =UUID.randomUUID();   
		String str = uuid.toString();  
		// 去掉"-"符号   
		return str.replace("-", "");
	}
	
}
