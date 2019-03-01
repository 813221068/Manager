package cn.edu.swust.query;

import lombok.Data;

@Data
public class DeclareStepQuery {
	/***
	 * 申报项目id
	 */
	private int declareBusinessId;
	/***
	 * 申报项目ids
	 */
	private int[] declareBusinessIds;
}
