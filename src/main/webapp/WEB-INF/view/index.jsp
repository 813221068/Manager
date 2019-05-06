<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>业务申报审批系统 - 首页</title>
	<%@ include file="common.jsp"%>
</head>
<body class="full-layout gray-bg" >
	<jsp:include page="navbar.jsp"></jsp:include>
	<jsp:include page="header.jsp"></jsp:include>
	<div class="content" id="content">
		欢迎用户：${user.username}  使用业务申报审批系统
	</div>
	<jsp:include page="footer.jsp"></jsp:include>
</body>
<script type="text/javascript">
// 	window.onload = function() {
// 		var userId = ${user.userId};
// 		$.ajax({
// 			type : 'post',
// 			url : "getPmsList",
// 			dataType : 'json',
// 			data : {"userId" : userId},
// 			success : function(pmsList) {
<%-- 				var pmsAll =<%=session.getAttribute("pmsAll")%>; --%>
// 					for ( var i in pmsAll) {
// 						var pms = pmsAll[i];
// 						if (isnull(_.find(pmsList, pms))) {
// 							console.log(pms.permissionName);
// 							document.getElementById(pms.permissionName).style.display = "none";
// 						}
// 					}
// 				}
// 		});
		
// 	};

$(document).ready(function(){
var vue = new Vue({
	el: '#content',
	data:function() {
		return {
		};
	},
	mounted:function(){
		if(${pmsRoleMark}){
			<% session.setAttribute("pmsRoleMark", false);%>
			this.$message.error('没有角色管理权限 无法进入页面');
		}
		if(${pmsDeclareMark}){
			<% session.setAttribute("pmsDeclareMark", false);%>
			this.$message.error('没有业务申报权限 无法进入页面');
		}
		if(${pmsApprovalMark}){
			<% session.setAttribute("pmsApprovalMark", false);%>
			this.$message.error('没有业务审批权限 无法进入页面');
		}
		if(${pmsBusinessMark}){
			<% session.setAttribute("pmsBusinessMark", false);%>
			this.$message.error('没有业务管理权限 无法进入页面');
		}
	},
	methods:{
	}
});
});
</script>
</html>