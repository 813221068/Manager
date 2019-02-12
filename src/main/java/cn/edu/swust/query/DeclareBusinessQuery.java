package cn.edu.swust.query;

import lombok.Data;

@Data
public class DeclareBusinessQuery {
	/***
	 * 项目id
	 */
	private int businessId;
	/***
	 * 项目ids
	 */
	private int[] businessIds;
	
}
