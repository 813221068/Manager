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
		HashMap<String, String> map = new HashMap<>();
		map.put("1", "1");
		Scanner scanner = new Scanner(System.in);
		while(scanner.hasNext()) {
			String string = scanner.nextLine();
			System.out.println(test(string));
			
		}
		
	}

}
