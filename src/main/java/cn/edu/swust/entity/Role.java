package cn.edu.swust.entity;

import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Role {

	private int roleId;
	
	private String roleName;
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") 
	private Date createTime;
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") 
	private Date updateTime;
	
	private String createUId;
	
	private String roleDesc;
	/**
	 * 可编辑  0是不可以编辑  1是可以编辑   
	 */
	private int editable;
	/***
	 * 是否可用  0是不可用   1是可用
	 */
	private int isEnable;
	
	/*****************************/
	private List<User> owners;
	
	private User createUser;
	
	private List<Permission> pmsList;
	
	/****************************/

	@Override	
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Role other = (Role) obj;
		if(this.roleId != other.roleId)
			return false;
		return true;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + roleId;
		return result;
	}
	
	
}
