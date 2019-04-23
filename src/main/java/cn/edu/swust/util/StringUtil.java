package cn.edu.swust.util;

import java.util.Random;
import java.util.UUID;

public class StringUtil {
	
	private static int[] nums = new int[] {0,1,2,3,4,5,6,7,8,9};

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
	/**
	 * 生成由数字随机组成的字符串
	 * @param length 字符串长度
	 * @return
	 */
	public static String getNumStr(int length) {
		StringBuilder sb = new StringBuilder();
		Random random = new Random();
		for(int i=0;i<length;i++) {
			sb.append(random.nextInt(10));
		}
		return String.valueOf(sb);
	}
	
	public static void main(String[] args) {
		
		for(int i=0;i<10;i++) {
			System.out.println(getNumStr(4));
		}
	}
}
