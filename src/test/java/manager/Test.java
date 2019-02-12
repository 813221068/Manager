package manager;

import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public class Test {
	
	public static int test(String key) {
		int h;
		return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
	}
	
	public static void main(String[] args) {
	System.out.println("123"+"\r\n123");
		
	}

}
