package cn.edu.swust.query;

import lombok.Data;

@Data
public class DealQuery {

	/***
	 * 所属项目id
	 */
	private int businessId;
	/**
	 * 项目ids
	 */
	private int[] businessIds;
}
