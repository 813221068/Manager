package manager;

import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

import org.springframework.scheduling.config.Task;

import com.sun.javafx.binding.StringFormatter;
import com.sun.org.apache.regexp.internal.recompile;

import cn.edu.swust.util.EncodeUtil;
import cn.edu.swust.util.LogHelper;

class Cust{
	public String name;
}
public class Test {

	public static void main(String[] args) {
		Cust[] custs = new Cust[2];
		Cust cust = new Cust();
		cust.name="1234";
		custs[0] = cust;
		System.out.println(custs);

	}
	
}
