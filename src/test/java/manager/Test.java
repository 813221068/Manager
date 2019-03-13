package manager;

import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

import org.springframework.scheduling.config.Task;

import com.sun.org.apache.regexp.internal.recompile;

import cn.edu.swust.util.EncodeUtil;
import cn.edu.swust.util.LogHelper;

class Cust{
	public String name;
}
public class Test {

	public static void main(String[] args) {
		String string = EncodeUtil.decode64Base("e948576f30bd1669961698bf99cf5c93");
		System.out.println(string);
	}
	
}
