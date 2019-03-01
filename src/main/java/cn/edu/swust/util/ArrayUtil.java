package cn.edu.swust.util;

import java.util.List;

/**
 * 数组帮助类
 * @author user
 *
 */
public class ArrayUtil {
	/***
	 * list 转换成 int[]
	 * @param list
	 * @return
	 */
	public static int[] list2Array(List<Integer> list) {
		int[] array = null;
		if(list!=null && list.size()==0) {
			array = new int[list.size()];
			for(int i=0;i<list.size();i++) {
				array[i] = list.get(i);
			}
		}
		return array;
	}
}
