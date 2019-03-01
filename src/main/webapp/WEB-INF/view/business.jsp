<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>业务申报审批系统 - 业务管理</title>
	
	<%@ include file="common.jsp"%>
</head>
<body class="full-layout gray-bg" >
	<jsp:include page="navbar.jsp"></jsp:include>
	<jsp:include page="header.jsp"></jsp:include>
	<div class="content" id="content">
		<div>
			<h2>项目信息</h2>
		</div>
		<div class="table-bg">
            <div id="toolbar" class="btn-group table-tool">
                <el-button type="primary" icon="el-icon-plus" size="medium"  @click="addBsnsVsb = true">添加</el-button>
                <span class="display" id="batchBtn">
					<el-button icon="el-icon-delete" size="medium"  @click="batchDelete()">批量删除</el-button>
                </span>
               <!--  <button id="batchDelete" type="button" class="ant-btn display" onclick="batchDelete()">
                    <span><i class="fa fa-trash-o" aria-hidden="true"></i></span>批量删除
                </button> -->
            </div>
			<div class = "table">
			<!-- 	<table id="businessTable" >
				</table> -->
				<el-table :data="bsnsList" border stripe @selection-change="checkBoxChange">
						<el-table-column type="selection" >
						</el-table-column>
						<el-table-column label="项目ID" align='center'>
							<template slot-scope="scope">
								<span style="margin-left: 10px">{{ scope.row.businessId }}</span>
							</template>
						</el-table-column>
						<el-table-column label="项目名称">
							<template slot-scope="scope">
								<span style="margin-left: 10px">{{ scope.row.businessName }}</span>
							</template>
						</el-table-column>
						<el-table-column label="项目描述">
							<template slot-scope="scope">
								<span style="margin-left: 10px">{{ scope.row.businessDesc }}</span>
							</template>
						</el-table-column>
						<el-table-column label="创建人">
							<template slot-scope="scope">
								<el-popover trigger="hover" placement="top">
									<p>用户ID: {{ scope.row.createUser.userId}}</p>
									<p>用户名:{{ scope.row.createUser.username}}</p>
									<div slot="reference" class="name-wrapper">
										<el-tag size="medium">{{ scope.row.createUser.username }}</el-tag>
									</div>
								</el-popover>
							</template>
						</el-table-column>
						<el-table-column label="创建时间">
							<template slot-scope="scope">
								<i class="el-icon-time"></i>
								<span style="margin-left: 10px">{{ scope.row.createTime }}</span>
							</template>
						</el-table-column>
						<el-table-column label="更新时间">
							<template slot-scope="scope">
								<i class="el-icon-time"></i>
								<span style="margin-left: 10px">{{ scope.row.updateTime }}</span>
							</template>
						</el-table-column>
						<el-table-column label="操作">
							<template slot-scope="scope">
								<el-button size="mini" @click="handleEdit(scope.$index, scope.row)">编辑</el-button>
								<el-popover placement="top" width="160" v-model="scope.row.cfmVisible" trigger="click">
									<div class="text-center">
										<p>确定删除该项目吗</p>
										<el-button size="mini" type="text" @click="scope.row.cfmVisible = false">取消</el-button>
										<el-button type="primary" size="mini" @click="deleteBsns(scope.$index, scope.row)">确定</el-button>
									</div>
									<el-button size="mini" type="danger" slot="reference" >删除</el-button>
								</el-popover> 
							</template>
						</el-table-column>
					</el-table>
			</div>
		</div>
		<el-dialog :visible.sync="addBsnsVsb" title="项目信息" :append-to-body="true"  :modal-append-to-body='false' width="20%" :close-on-click-modal="false">
			<el-dialog title="添加审批流程" :visible.sync="stepModalVisible" width="20%" height="80%" 
			:modal-append-to-body='false' :close-on-click-modal="false" :append-to-body="true">
				<el-form :rules="stepRules" :model="stepForm" status-icon label-width="90px" ref="stepForm">
					<el-form-item label="流程名：" prop="stepName" >
   						<el-input placeholder="请输入流程名" v-model="stepForm.stepName" style="width: 80%;" clearable>
 					</el-form-item>
 					<el-form-item label="审批角色:" prop="sltRole">
 						<el-select v-model="stepForm.sltRole" value-key="roleId" placeholder="选择审批角色" @change="showUser()" clearable>
 							<el-option v-for="role in roles" :key="role.roleId" :value="role" :label="role.roleName"></el-option>
 						</el-select>
 					</el-form-item>
 					<el-form-item label="审批用户:" v-if="sltUserVsb">
						<el-select v-model="stepForm.sltUser" value-key="userId" placeholder="选择审批用户" clearable>
 							<el-option v-for="user in stepForm.users" :key="user.userId" :value="user" :label="user.username"></el-option>
 						</el-select>
 					</el-form-item>
				</el-form>
				<span slot="footer">
					<el-button @click="hideStepModal('stepForm','stepModalVisible')">取 消</el-button>
					<el-button type="primary" @click="addStep('stepForm')">确 认</el-button>
				</span>
  			</el-dialog>
  			<el-form :model="bsnsForm" label-width="90px" :rules="bsnsRules"  status-icon ref="bsnsForm">
				<el-form-item label="项目名：" prop="bsnsName"  >
   					<el-input placeholder="请输入项目名" v-model="bsnsForm.bsnsName" style="width: 80%;" clearable>
 				</el-form-item>
 				<el-form-item label="项目描述：" >
   					<el-input placeholder="请输入项目描述" v-model="bsnsForm.bsnsDesc" style="width: 80%;" clearable>
 				</el-form-item>
 				<el-form-item label="审批流程：">
					<el-steps  :active="0" >
					<el-step :title="step.stepName" :description="step.description" v-for="step in steps"></el-step>
				</el-steps>
				<el-button type="primary" size="mini" icon="el-icon-plus" @click="stepModalVisible = true"></el-button>
  				</el-form-item>
  			</el-form>
			<span slot="footer">
				<el-button @click="addBsnsVsb = false">取 消</el-button>
    			<el-button type="primary" @click="modalOnclick()">确 认</el-button>
			</span>
		</el-dialog>
	</div>
	<jsp:include page="footer.jsp"></jsp:include>
</body>
<script type="text/javascript">
//modal标志位  0是添加   1是修改
var modalOperating = 0;
//流程数最大值
var stepMaxCount = 3; 
var sltBusiness;
$(document).ready(function(){
	function deleteBsnsFunc(args){
		$.ajax({
			url:"deleteBusiness",
			data:args,
			type:"get",
			traditional: true,//传递数组
			success:function(data){
				if(data==0){
					toastr.error("删除失败");
				}else{
					toastr.success("删除成功");
				}
				loadTableData();
			},
			error:function(){
				toastr.error("请求失败");
			},
		});
	};
var vue = new Vue({
	el: '#content',
	data:function() {
        var checkBsnsName = (rule, value, callback) => {
		if (value.length<3) {
            callback(new Error('项目名称长度不能小于3'));
        } else if(value.length>10){
          	callback(new Error('项目名称长度不能超过10'));
        }else{
          	callback();
        }
     	};
		return {
			bsnsForm:{
				bsnsName:'',
				bsnsDesc:'',
			},
			stepForm:{
				stepName:'',
				sltRole:'',
				sltUser:'',
				users:[],
			},
			bsnsRules:{
				bsnsName:[{ required: true, message: '项目名不能为空'},
						{validator: checkBsnsName, trigger: 'blur' }],
			},
			stepRules:{
				stepName:[  { required: true, message: '流程名不能为空'},],
				sltRole:[{required:true,message:'审批角色不能为空'}]
			},
			bsnsList: [],
			addBsnsVsb:false,
			sltUserVsb:false,  //审批用户下拉框vsb
			stepModalVisible:false,
			steps:[],
			roles:[],
		};
	},
	mounted:function(){
		loadTableData();
		$.ajax({
			url:"getRoleList",
			// data:,
			type:"get",
			traditional: true,//传递数组
			contentType:"application/json;charset=UTF-8",
			success:function(data){
				if(data!=null && data.length!=0){
					vue.roles = data;
				}else{
					toastr.error("查询失败");
				}
			},
			error:function(){
				toastr.error("请求失败");
			},
		});
	},
	methods:{
		checkBoxChange:function(val){
			this.multipleSelection = val;
			var batchBtn = document.getElementById('batchBtn');
			if(val.length>0){
				batchBtn.style.display = "inline";
			}else{
				batchBtn.style.display = "none";
			}
			
		},
		handleEdit:function(index,row){
			$('#businessModal').modal('show');
			document.getElementById('businessName').value = row.businessName;
			document.getElementById('businessDesc').value = row.businessDesc;
			modalOperating = 1;
			sltBusiness = row;
		},
		deleteBsns:function(index,row){
			row.cfmVisible = false;
			var data = {"businessId":row.businessId};
			deleteBsnsFunc(data);
		},
		batchDelete:function(){
			var ids = new Array;
			for(var row of this.multipleSelection){
				ids.push(row.businessId);
			}
			var data = {"businessIds":ids};
			deleteBsnsFunc(data);
		},
		addStep:function(formName){
			this.$refs[formName].validate((valid) =>{
				if(valid){
					this.stepModalVisible = false;
					if()
					return;
				}else{
					return;
				}
			});
			
			if(this.steps.length<stepMaxCount){
				if(!isnull(this.sltRole)){
					var description = this.sltRole.roleName;
					if(!isnull(this.sltUser)){
						description += " ---- " +  this.sltUser.username;
					}
					var step = {"stepName":this.stepName,"description":description};//,"username":username
					this.steps.push(step);
					loadTableData();
				}else{
					//没有选择角色 
				}
			}else{
				toastr.error("添加失败，超过最大值");
			}
		},
		//展示选中角色下的所有用户 
		showUser:function(){
			if(!isnull(this.stepForm.sltRole)){
				$.ajax({
					url:"getUserList",
					data:JSON.stringify({"roleId":this.stepForm.sltRole.roleId}),
					dataType:"json",
					type:"post",
					traditional: true,//传递数组
					contentType:"application/json;charset=UTF-8",
					success:function(data){
						vue.stepForm.users = [];
						for(var user of data){
							vue.stepForm.users.push(user);
						}
					},
					error:function(){
						toastr.error("请求失败");
					},
				});
				this.sltUserVsb = true;
			}else{
				this.sltUserVsb = false;
			}
		},
		//隐藏dialog 并清空对应form
		hideModal:function(formName,visible){
			this[visible] = false;
			this.$refs[formName].resetFields();
		},
		hideStepModal:function(formName,visible){
			this.hideModal(formName,visible);
			this.sltUserVsb = false;
		},
	
	}
});
//刷新table数据
function loadTableData(){
	$.ajax({
			url:"businessList",
			type:"get",
        	traditional: true,//传递数组
        	success:function(data){
        		//todo 修改modal 替换成kong
        		var list = [];
        		var visibleList = [];
        		var i = 0;
        		for(var bsns of data){
        			bsns.createTime = moment(data.createTime).format("YYYY-MM-D  HH:mm:ss");
        			bsns.updateTime = moment(data.updateTime).format("YYYY-MM-D  HH:mm:ss");
        			if(isnull(bsns.businessDesc)){
        				bsns.businessDesc = "暂无数据";
        			}
        			list.push(bsns);
        			bsns.cfmVisible = false;
        		}
        		vue.bsnsList = list;
        	},
        	error:function(){
        		toastr.error("请求失败");
        	},
   		 });
};
});
function addBusiness(data) {
    var addResult = 0;
    $.ajax(
        {
            url: "addBusiness",
            data:JSON.stringify(data),
            dataType:"json",  
            type: "post",
            contentType:"application/json;charset=UTF-8",
            success:function(row)
            {
                addResult = row;
            },
            error:function()
            {
                toastr.error("请求失败");
            },
            complete:function()
            {
                $('#businessModal').modal('hide');
                $("#businessTable").bootstrapTable('refresh');
                if(addResult>0){
                    toastr.success("添加项目成功");
                     $('#businessTable').bootstrapTable('refresh');
                }
                else if(addResult==0){
                    toastr.error("添加项目失败");
                }
                
            }
        });

    return false;
};
function updateBusiness(data){
    data.businessId = sltBusiness.businessId;
    var updateResult = 0;
    $.ajax(
        {
            url: "updateBusiness",
            data:JSON.stringify(data),
            dataType:"json",  
            type: "post",
            contentType:"application/json;charset=UTF-8",
            success:function(row)
            {
                updateResult = row;
            },
            error:function()
            {
                toastr.error("请求失败");
            },
            complete:function()
            {
                $('#businessModal').modal('hide');
                $("#businessTable").bootstrapTable('refresh');
                if(updateResult>0){
                    toastr.success("修改项目信息成功");
                    $('#businessTable').bootstrapTable('refresh');
                }
                else if(updateResult==0){
                    toastr.error("修改项目信息失败");
                } 
            }
        });
    return false;
};
</script>
</html>