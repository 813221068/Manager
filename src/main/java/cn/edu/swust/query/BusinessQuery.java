package cn.edu.swust.query;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class BusinessQuery extends BaseQuery {
	
	private int[] businessIds;
	
	private int businessId;
	
	public boolean isNull() {
		if(businessId!=0 || (businessIds!=null && businessIds.length>0)) {
			return false;
		}
		return true;
	}
}
