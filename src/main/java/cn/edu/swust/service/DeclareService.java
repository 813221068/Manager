package cn.edu.swust.service;

import java.io.File;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import cn.edu.swust.query.DeclareBusinessQuery;
import cn.edu.swust.util.LogHelper;
import cn.edu.swust.util.PropertiesUtil;

@Service
public class DeclareService {

	/**
	 * 申报文件上传  不存库，存文件
	 * @param files
	 * @param query
	 * @return
	 */
	public boolean uploadFile(MultipartFile[] files,DeclareBusinessQuery query) {
		boolean ret = true;
		try {
			for(MultipartFile file : files) {
				String fileName = query.getDeclareUserId()+"_"+query.getBusinessId()+"_"+file.getOriginalFilename();
				String savePath = PropertiesUtil.getValue("savePath")+fileName;
				System.out.println("path:"+savePath);
				file.transferTo(new File(savePath));
			}
			
		}
		catch (Exception e) {
			LogHelper.logError(e);
			ret = false;
		}
		return ret;
	}
}
