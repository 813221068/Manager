package cn.edu.swust.service;

import static org.junit.Assert.assertNotNull;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Set;

import org.apache.ibatis.jdbc.SQL;
import org.aspectj.apache.bcel.classfile.Field;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.web.multipart.MultipartFile;

import cn.edu.swust.ReqEntity.DownloadFileReq;
import cn.edu.swust.dao.BusinessDao;
import cn.edu.swust.dao.DeclareBusinessDao;
import cn.edu.swust.dao.DeclareStepDao;
import cn.edu.swust.dao.StepDao;
import cn.edu.swust.dao.UserDao;
import cn.edu.swust.entity.Business;
import cn.edu.swust.entity.DeclareBusiness;
import cn.edu.swust.entity.Step;
import cn.edu.swust.query.BusinessQuery;
import cn.edu.swust.query.DeclareBusinessQuery;
import cn.edu.swust.query.DeclareStepQuery;
import cn.edu.swust.query.RolePermissionQuery;
import cn.edu.swust.query.StepQuery;
import cn.edu.swust.query.UserQuery;
import cn.edu.swust.util.LogHelper;
import cn.edu.swust.util.ObjectConvert;

@Service
public class BusinessService {
	@Autowired
	private BusinessDao businessDao;
	@Autowired
	private UserDao userDao;
	@Autowired
	private StepDao stepDao;
	@Autowired
	private DeclareBusinessDao declareBusinessDao;
	@Autowired
	private DeclareStepDao declareStepDao;
	
	public List<Business> getBusinessList(BusinessQuery query){
		List<Business> businesses = new ArrayList<>();
		try {
			List<Business> list = businessDao.queryList(query);
			for(Business bsn : list) {
				UserQuery userQuery = new UserQuery();
				userQuery.setUserId(bsn.getCreateUserId());
				
				bsn.setCreateUser(userDao.query(userQuery));
				
				StepQuery stepQuery = new StepQuery();
				stepQuery.setBusinessId(bsn.getBusinessId());
				
				bsn.setSteps(stepDao.queryList(stepQuery));
				
				businesses.add(bsn);
			}
		} catch (Exception e) {
			LogHelper.logError(e);
		}
		return businesses;
	}
	/***
	 * 添加项目  
	 * @param business  项目信息
	 * @param steps   项目审批过程 list
	 * @return  插入Id
	 */
	public int insertBusiness(Business business,List<Step> steps) {
		int bsnsId = 0;
		try {
			if(business.getCreateUserId()==null||business.getCreateUserId()==""||steps==null||steps.size()==0) {
				return bsnsId;
			}
			business.setStatus(1);
			business.setIsEnable(1);
			businessDao.setPrimaryValue(1);
			bsnsId = businessDao.insertOneSelective(business);
			
			if(bsnsId != 0) {
				for(Step step : steps) {
					step.setBusinessId(bsnsId);
				}
				
				stepDao.setPrimaryValue(1);
				stepDao.batchInsert(steps);
			}
			
		} catch (Exception e) {
			LogHelper.logError(e);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			bsnsId = 0;
		}
		
		return bsnsId;
	}
	/**
	 * 批量删除  
	 * @param ids
	 * @return  0是全部失败  1是部分失败  2是全部成功
	 */
	public int batchDelete(int[] ids) {
		int successCount = 0;
		if(ids!=null && ids.length>0) {
			BusinessQuery query = new BusinessQuery();
			for(int id : ids) {
				query.setBusinessId(id);
				successCount += delete(query)>0?1:0;
			}
		}
		if(successCount==0) {
			return 0;
		}
		return successCount==ids.length?2:1;
	}
	/**
	 * 删除项目信息
	 * @param query
	 * @return 影响行数
	 */
	public int delete(BusinessQuery query) {
		int ret = 0;
		try {
			//原逻辑  删除business表数据、删除step表数据、已经申报的项目不能删除
//			DeclareBusinessQuery dclrBsnsQuery = new DeclareBusinessQuery();
//			ObjectConvert.obj2Obj(query, dclrBsnsQuery);
//
//			boolean isDeclare = declareBusinessDao.count(dclrBsnsQuery)==0?false:true;
//
//			if(!isDeclare) {
//				ret = businessDao.delete(query);
//				StepQuery stepQuery = new StepQuery();
//				ObjectConvert.obj2Obj(query, stepQuery);
//				stepDao.delete(stepQuery);
//			}
			//新逻辑 增加字段isEnable 
			Business business = new Business();
			business.setBusinessId(query.getBusinessId());
			business.setUpdateTime(new Date());
			
			ret = businessDao.deleteById(business);
			
		}catch (Exception ex) {
			LogHelper.logError(ex);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			ret = 0;
		}
		return ret;
	}
	/***
	 * 更新项目信息   状态为草稿的项目
	 * @param business
	 * @param steps 
	 * @return 
	 */
	public boolean update(Business business,List<Step> steps) {
		int result = 0;
		try {
			result = businessDao.updateByPrimaryKeySelective(business);
			
			if(steps!=null && steps.size()>0) {
				StepQuery query = new StepQuery();
				query.setBusinessId(business.getBusinessId());
				
				List<Step> oldSteps = stepDao.queryList(query);
				
				for(Step step : steps) {
					//插入新流程
					if(step.getStepId() == 0) {
						step.setBusinessId(business.getBusinessId());
						
						stepDao.setPrimaryValue(1);
						stepDao.insertOneSelective(step);
					}else {
						//更新旧流程
						oldSteps.remove(step);
						stepDao.updateByPrimaryKeySelective(step);
					}
				}

				//删除已删除的流程
				if(oldSteps != null && oldSteps.size()>0) {
					int[] ids = new int[oldSteps.size()];
					for(int i=0;i<oldSteps.size();i++) {
						ids[i] = oldSteps.get(i).getStepId();
					}
					
					query = new StepQuery();
					query.setStepIds(ids);

					stepDao.delete(query);
				}
			}
			
		}catch (Exception e) {
			LogHelper.logError(e);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			result = 0;
		}
		return result==0?false:true;
	}
	
	public boolean uploadFile(MultipartFile file,String savePath,Business bsns) {
		boolean ret = true;
		File saveFile = new File(savePath);
		if(!saveFile.exists() || !saveFile.isDirectory()) {
			saveFile.mkdir();
		}
		
		try {
			// 文件对应申报项目 文件名：业务id
			String fileName = bsns.getBusinessId()+"_"+ file.getOriginalFilename();
//			String suffix = fileName.substring(fileName.lastIndexOf(".")+1);
			String filePath = savePath + File.separator + fileName;
			File tmpFile = new File(filePath);
			file.transferTo(tmpFile);
		} catch (IllegalStateException |IOException e) {
			LogHelper.logError(e, "文件保存失败");
			ret = false;
		}
		
		return ret;
	}
	/**
	 * 获取txt文件
	 * @param filePath
	 * @param bsns
	 * @return
	 */
	public File getFile(String filePath,DownloadFileReq req) {
//		System.out.println("fileName:"+bsns.getFileName());
		File rootPath = new File(filePath);
		File retFile = null;
		
		if(rootPath.exists()) {
			File[]  files = rootPath.listFiles();
			for (File file : files) {
				String fileName =  file.getName();
				String prefix = fileName.substring(0,fileName.lastIndexOf("_"));
				String suffix = fileName.substring(fileName.lastIndexOf("_")+1);
				if(prefix.equals(req.getFileName())) {
					retFile = file;
					req.setRealFileName(suffix);
					break;
				}
			}
		}
		
		return retFile;
	}
}
