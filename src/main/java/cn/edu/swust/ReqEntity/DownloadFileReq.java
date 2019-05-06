package cn.edu.swust.ReqEntity;

import lombok.Data;

@Data
/**
 * 文件下载请求类
 * @user:肖家林
 *
 * @time:下午4:57:38
 */
public class DownloadFileReq {
	/**
	 * 路径  申报要求：upload     申报资料：declareFiles
	 */
	private String path;
	/**
	 * 文件真实名
	 */
	private String realFileName;
	/**
	 * 保存名    申报要求：业务id+     申报资料：用户id_业务id 
	 */
	private String fileName;
}