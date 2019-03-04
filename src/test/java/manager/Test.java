package manager;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

import com.sun.org.apache.bcel.internal.generic.NEW;

import cn.edu.swust.query.UserQuery;
import cn.edu.swust.query.UserRoleQuery;

class Cust{
	public String name;
}
public class Test {

	public static void main(String[] args) {
		ArrayList<Cust> list = new ArrayList<>();
		Object object = new Object();
		Cust cust = new Cust();
		cust.name = "123";
		list.add(cust);
		list.equals(new ArrayList<Cust>());
		for(Cust tmp:list) {
			cust.name = "321";
		}
		System.out.println(list.get(0).name);
	}

}
