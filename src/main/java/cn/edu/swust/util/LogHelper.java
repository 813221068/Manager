package cn.edu.swust.util;

import org.apache.log4j.Logger;
/**
 * 日志帮助类
 * @author user
 *
 */
public class LogHelper {

	private static Logger logger = Logger.getLogger(LogHelper.class);
	
	public static void logError(Exception ex) {
		logger.error(ex);
	}
	
	public static void logError(String msg) {
		logger.error(msg);
	}
	
	public static void logError(Exception e , String msg) {
		logger.error(msg, e);
	}
	
	public static void logInfo(String msg) {
		logger.info(msg);
	}
	
}
