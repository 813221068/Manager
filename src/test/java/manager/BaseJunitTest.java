package manager;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.sun.xml.internal.messaging.saaj.packaging.mime.util.QDecoderStream;

import cn.edu.swust.dao.BusinessDao;
import cn.edu.swust.dao.PermissionDao;
import cn.edu.swust.dao.RoleDao;
import cn.edu.swust.dao.StepDao;
import cn.edu.swust.entity.Business;
import cn.edu.swust.entity.Role;
import cn.edu.swust.entity.Step;
import cn.edu.swust.entity.User;
import cn.edu.swust.query.BusinessQuery;
import cn.edu.swust.query.PermissionQuery;
import cn.edu.swust.query.RoleQuery;
import cn.edu.swust.query.UserQuery;
import cn.edu.swust.service.BusinessService;
import cn.edu.swust.service.RoleService;
import cn.edu.swust.service.UserService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations="classpath:spring-servlet.xml")
public class BaseJunitTest {

	@Autowired
	RoleService roleService;
	@Autowired
	PermissionDao pmsDao;
	@Autowired
	RoleDao  roleDao; 
	@Autowired
	StepDao stepDao;
	@Autowired
	BusinessService businessService;
	@Autowired
	BusinessDao businessDao;
	@Autowired
	UserService userService;
	
	
	@Test
	public void test() {
//		Business business = new Business();
//		business.setBusinessName("test");
//		business.setCreateTime(new Date());
//		business.setUpdateTime(new Date());
//		Deal deal = new Deal();
//		deal.setDealName("update");
//		deal.setBusinessId(2);
//		List<Deal> list = new ArrayList<>();
//		list.add(deal);
//		list.add(deal);
////		System.out.println(businessService.insertBusiness(business, list));
//		
//		Business business = new Business();
//		business.setBusinessId(2);
//		business.setBusinessName("update");
		
//		BusinessQuery query = new BusinessQuery();
//		query.setBusinessId(2);
//		System.out.println(businessService.delete(query));
		
//		Business business = new Business();
//		business.setBusinessId(2);
//		business.setBusinessName("test");
//		List<Step> steps = new ArrayList<>();
//		Step step = new Step();
//		step.setStepId(4);
//		step.setBusinessId(2);
//		step.setStepName("test");
//		
//		steps.add(step);
//		business.setSteps(steps);
		
//		RoleQuery query = new RoleQuery();
//		List<Role> list = roleService.queryList(query);
//		for(Role role : list) {
//			System.out.println(JSONObject.toJSONString(role,SerializerFeature.WriteMapNullValue));
//		}
		
		userService.getPmsList(new PermissionQuery());
		
		
	}
}
