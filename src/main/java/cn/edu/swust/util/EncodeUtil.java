package cn.edu.swust.util;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.io.UnsupportedEncodingException;

import sun.misc.BASE64Decoder;
public class EncodeUtil {
	/**
	 * 将字符串以md5加密
	 * @param str
	 * @return 32位字符串
	 */
	public static String encodeByMD5(String str) {
		byte[] bytes = null;
		try {
			MessageDigest md5 = MessageDigest.getInstance("MD5");
			md5.update(str.getBytes("utf-8"));
			bytes =  md5.digest(str.getBytes("utf-8"));
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			LogHelper.logError(e); //log4j日志输出，可注释
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return bytesTo16BString(bytes);
	}
	/**
	 * 字节流转换成16进制string
	 * @param bytes
	 * @return
	 */
	private static String bytesTo16BString(byte[] bytes) {
		StringBuffer res = new StringBuffer();
		int num = 0;
		for(int i=0;i<bytes.length;i++) {
			num = bytes[i]>0?bytes[i]:255+bytes[i];
			String hex = Integer.toHexString(num);
			res.append(hex.length()<2?0+hex:hex);
		}
		return res.toString();
	}
	/**
	 * base64 解码
	 * @param str
	 * @return
	 */
	@SuppressWarnings("restriction")
	public static String decode64Base(String str) {
		BASE64Decoder decoder = new BASE64Decoder();
		String ret = null;
		try {
			byte[] b = decoder.decodeBuffer(str);
			ret = new String(b, "UTF-8");
		} catch (Exception ex) {
			LogHelper.logError(ex);
		}
		return ret;
	}
	
	public static void main(String[] args) {
		System.out.println("e948576f30bd1669961698bf99cf5c93".length());
	}
}
