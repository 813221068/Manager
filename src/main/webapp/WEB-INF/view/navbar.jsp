<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!--左侧导航开始-->
<div class="navbar">
		<ul class="nav" id="side-menu">
			<li class="nav-header">
				<a href="">业务申报审批系统</a>
			</li>
			<li>
				<a href="index">
					 <i class="fa fa-circle-o-notch"></i> 
					 <span>主页</span>
				</a>
			</li>
			<li><a href="declare"> <i class="fa fa fa-bar-chart-o"></i> <span
					>业务申报</span>
			</a></li>
			<li><a href="approval"> <i class="fa fa-paint-brush"></i> <span
					>业务审批</span>
			</a></li>
			<li>
				<a href="business"> <i class="fa fa-edit"></i> 
					<span>业务管理</span>
				
				</a>

			</li>
			<!-- <li><a href="user"> <i class="fa fa-table"></i> <span
					>用户管理</span>
			</a></li> -->
			<li id="roleManager">
				<a href="role" >
					<i class="fa fa-desktop"></i>
					<span >角色管理</span>
<!-- 					<i class="fa arrow" aria-hidden="true"></i> -->
				</a>
<!-- 				<ul class="nav nav-second-level"> -->
<!-- 					<li id="showRole"><a href="role/list" data-index="0">角色列表</a></li> -->
<!-- 					<li id="updateRole"><a href="">修改角色</a></li> -->
<!-- 				</ul> -->
			</li>
		</ul>
	</div>
<!--左侧导航结束-->