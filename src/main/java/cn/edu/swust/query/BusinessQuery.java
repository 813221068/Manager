package cn.edu.swust.query;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class BusinessQuery extends BaseQuery {
	/***
	 * 批量删除项目ids
	 */
	private int[] businessIds;
	/***
	 * 项目id
	 */
	private int businessId;
	/***
	 * 项目名称
	 */
	private String businessName;
	/**
	 * 项目状态    1->草稿  2->正式
	 */
	private int status;
}
