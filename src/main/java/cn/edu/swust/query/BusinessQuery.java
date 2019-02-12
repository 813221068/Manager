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
}
