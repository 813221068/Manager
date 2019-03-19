package cn.edu.swust.service;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.web.multipart.MultipartFile;

import cn.edu.swust.dao.DeclareBusinessDao;
import cn.edu.swust.dao.DeclareStepDao;
import cn.edu.swust.dao.StepDao;
import cn.edu.swust.entity.DeclareBusiness;
import cn.edu.swust.entity.DeclareStep;
import cn.edu.swust.entity.Step;
import cn.edu.swust.query.DeclareBusinessQuery;
import cn.edu.swust.query.StepQuery;
import cn.edu.swust.util.LogHelper;
import cn.edu.swust.util.ObjectConvert;
import cn.edu.swust.util.PropertiesUtil;

@Service
public class DeclareService {

	@Autowired
	private DeclareBusinessDao declareBusinessDao;
	@Autowired
	private DeclareStepDao declareStepDao;
	@Autowired
	private StepDao stepDao;
	
	/**
	 * 申报文件上传  不存库，存文件  userId_BsnsId_fileName
	 * @param files
	 * @param query
	 * @return
	 */
	public boolean uploadFile(MultipartFile[] files,DeclareBusiness declareBusiness) {
		int ret = 0;
		try {
			StepQuery stepQuery = new StepQuery();
			ObjectConvert.obj2Obj(declareBusiness, stepQuery);
			
			List<DeclareStep> declareSteps = new ArrayList<>();
			for(Step step : stepDao.queryList(stepQuery)) {
				DeclareStep declareStep = new DeclareStep();
				declareStep.setDeclareBusinessId(declareBusiness.getBusinessId());
				declareStep.setStepId(step.getStepId());
				declareStep.setStatus(1);
				
				declareSteps.add(declareStep);
			}
			ret = declareStepDao.insertBatch(declareSteps);
			
			declareBusiness.setStatus(1);
			ret = declareBusinessDao.insertOneSelective(declareBusiness);
			
			for(MultipartFile file : files) {
				String fileName = declareBusiness.getDeclareUserId()+"_"+declareBusiness.getBusinessId()+"_"+file.getOriginalFilename();
				String savePath = PropertiesUtil.getValue("savePath")+fileName;
				
				file.transferTo(new File(savePath));
			}
			
		}
		catch (Exception e) {
			LogHelper.logError(e);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ret = 0;
		}
		return ret!=0;
	}
}
