package cn.edu.swust.service;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.web.multipart.MultipartFile;

import com.sun.org.apache.regexp.internal.recompile;
import com.sun.swing.internal.plaf.basic.resources.basic;

import cn.edu.swust.dao.DeclareBusinessDao;
import cn.edu.swust.dao.DeclareStepDao;
import cn.edu.swust.dao.StepDao;
import cn.edu.swust.entity.Business;
import cn.edu.swust.entity.DeclareBusiness;
import cn.edu.swust.entity.DeclareStep;
import cn.edu.swust.entity.Step;
import cn.edu.swust.entity.User;
import cn.edu.swust.query.BusinessQuery;
import cn.edu.swust.query.DeclareBusinessQuery;
import cn.edu.swust.query.StepQuery;
import cn.edu.swust.util.LogHelper;
import cn.edu.swust.util.ObjectConvert;
import cn.edu.swust.util.PropertiesUtil;
import sun.security.krb5.internal.crypto.Des;

@Service
public class DeclareService {
	@Autowired
	private BusinessService businessService;
	@Autowired
	private DeclareBusinessDao declareBusinessDao;
	@Autowired
	private DeclareStepDao declareStepDao;
	@Autowired
	private StepDao stepDao;
	
	/**
	 * 申报业务  
	 * @param files
	 * @param declareBusiness
	 * @return 
	 */
	public boolean declareBsns(MultipartFile file,DeclareBusiness declareBusiness,
			String savePath) {
		boolean ret = false;
		//先插入dlc_bsns表 
		try {
			
			declareBusiness.setStatus(1);
			int dclBsnsId = declareBusinessDao.insertOneSelective(declareBusiness);
			
			StepQuery stepQuery = new StepQuery();
			stepQuery.setBusinessId(declareBusiness.getBusinessId());
			
			List<DeclareStep> declareSteps = new ArrayList<>();
			boolean isStartStep = true;
			for(Step step : stepDao.queryList(stepQuery)) {
				DeclareStep declareStep = new DeclareStep();
				declareStep.setDeclareBusinessId(dclBsnsId);
				declareStep.setStepId(step.getStepId());
				declareStep.setStatus(1);
				if(isStartStep) {
					declareStep.setStatus(1);
					isStartStep = false;
				}else {
					declareStep.setStatus(0);
				}
				
				declareSteps.add(declareStep);
			}
			declareStepDao.insertBatch(declareSteps);
			
			ret = uploadFile(file,savePath,declareBusiness);
			
		} catch (Exception e) {
			LogHelper.logError(e);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ret = false;
		}
		return ret;
	}
	
	public boolean uploadFile(MultipartFile file,String savePath,DeclareBusiness dclBsns) {
		boolean ret = true;
		File saveFile = new File(savePath);
		if(!saveFile.exists() || !saveFile.isDirectory()) {
			saveFile.mkdir();
		}
		
		try {
			// 文件对应申报项目 文件名：用户id_业务id_原文件名
			String fileName = dclBsns.getDeclareUserId()+"_"+dclBsns.getBusinessId()+"_"+ file.getOriginalFilename();
			String filePath = savePath + File.separator + fileName;
			File tmpFile = new File(filePath);
			file.transferTo(tmpFile);
			
		} catch (IllegalStateException |IOException e) {
			LogHelper.logError(e, "文件保存失败");
			ret = false;
		}
		
		return ret;
	}
	
	public List<Business> getBusinessList(BusinessQuery query){
		DeclareBusinessQuery dclBsnsQry = new DeclareBusinessQuery();
		dclBsnsQry.setDeclareUserId(query.getDeclareUserId());
		List<DeclareBusiness> list = declareBusinessDao.queryList(dclBsnsQry);
		
		List<Business> bsnsList = businessService.getBusinessList(query);
		for(DeclareBusiness dclBsns:list) {
			for(Business bsns:bsnsList) {
				if(dclBsns.getBusinessId()==bsns.getBusinessId()) {
					bsns.setDeclare(true);
					break;
				}
			}
		}
		return bsnsList;
	}
	
	public List<Step> getDclSteps(DeclareBusinessQuery query){
		List<Step> steps = null;
		try {
			//排序 
			steps = stepDao.queryDclSteps(query);
			
		} catch (Exception e) {
			// TODO: handle exception
			LogHelper.logError(e);
		}
		return steps;
	}
}
