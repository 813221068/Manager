package manager;

import java.util.Scanner;

public class Test {
	public static void main(String[] args) {
		System.out.println(Thread.currentThread().getStackTrace()[1].getMethodName());
	}

}
