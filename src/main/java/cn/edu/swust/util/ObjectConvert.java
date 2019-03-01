package cn.edu.swust.util;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
/**
 * 对象转换类
 * @author user
 *
 */
public class ObjectConvert {
	/***
	 * 类属性之间转换
	 * @param source  转换来源
	 * @param target  转换目标
	 * @throws NoSuchMethodException
	 * @throws SecurityException
	 * @throws IllegalAccessException
	 * @throws IllegalArgumentException
	 * @throws InvocationTargetException
	 */
	public static void obj2Obj(Object source,Object target) throws NoSuchMethodException, SecurityException, IllegalAccessException, IllegalArgumentException, InvocationTargetException {
		for(Field fieldSource : source.getClass().getDeclaredFields()) {
			for(Field fieldTarget : target.getClass().getDeclaredFields()) {
				if(fieldSource.getName().equals(fieldTarget.getName()) && (fieldSource.getType() == 
						fieldTarget.getType() )) {
					String fieldName = fieldSource.getName();
					String methodName = fieldName.substring(0, 1).toUpperCase() + fieldName.substring(1);
					
					Method getMethod = source.getClass().getMethod("get" + methodName);
					Method setMethod = target.getClass().getMethod("set" + methodName,fieldTarget.getType());
					setMethod.invoke(target, getMethod.invoke(source));
				}
			}
		}
	}
}
