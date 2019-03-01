package manager;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

import cn.edu.swust.query.UserQuery;
import cn.edu.swust.query.UserRoleQuery;

class Cust{
	public String name;
}
public class Test {

	public static void main(String[] args) {
		List<Cust> list = new ArrayList<>();
		Cust cust = new Cust();
		cust.name = "123";
		list.add(cust);
		for(Cust tmp:list) {
			cust.name = "321";
		}
		System.out.println(list.get(0).name);
	}

}
