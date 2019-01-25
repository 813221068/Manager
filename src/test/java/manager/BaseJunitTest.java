package manager;

import java.util.Date;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import cn.edu.swust.dao.PermissionDao;
import cn.edu.swust.dao.RoleDao;
import cn.edu.swust.entity.Role;
import cn.edu.swust.query.PermissionQuery;
import cn.edu.swust.query.RoleQuery;
import cn.edu.swust.service.RoleService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations="classpath:spring-servlet.xml")
public class BaseJunitTest {

	@Autowired
	RoleService roleService;
	@Autowired
	PermissionDao pmsDao;
	@Autowired
	RoleDao  roleDao; 
	
	@Test
	public void test() {
		Role role = new Role();
		role.setRoleName("test");
		role.setCreateTime(new Date());
		role.setLastUpdateTime(new Date());
		role.setDesc("test");
		role.setCreateUId("2");
		System.out.println(roleDao.insertOne(role));
	}
}
