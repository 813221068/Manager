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
            </div>
			<div class = "table">
				<el-table :data="bsnsList" border stripe @selection-change="checkBoxChange" >
						<el-table-column type="selection" >
						</el-table-column>
						<el-table-column label="项目ID" align='center'>
							<template slot-scope="scope">
								<span style="margin-left: 10px">{{ scope.row.businessId }}</span>
							</template>
						</el-table-column>
						<el-table-column label="项目名称" align="center"> 
							<template slot-scope="scope">
								<el-popover trigger="hover" placement="top">
									<p>创建时间: {{ scope.row.createTime}}</p>
									<p>更新时间: {{ scope.row.updateTime}}</p>
									<p>项目描述: {{ scope.row.businessDesc}}</p>
									<div slot="reference" class="name-wrapper">
										<el-tag size="medium">{{ scope.row.businessName }}</el-tag>
									</div>
								</el-popover>
							</template>
						</el-table-column>
 						<el-table-column label="创建人" align="center">
							<template slot-scope="scope">
								<el-popover trigger="hover" placement="top">
									<p>用户ID: {{ scope.row.createUser.userId}}</p>
									<p>用户名: {{ scope.row.createUser.username}}</p>
									<div slot="reference" class="name-wrapper">
										<el-tag size="medium">{{ scope.row.createUser.username}}</el-tag>
									</div>
								</el-popover>
							</template>
						</el-table-column>
						<!-- bug -->
						<el-table-column label="状态" align="center">
							<template slot-scope="scope">
								<span style="margin-left: 10px;color: {{scope.row.status==0?draftColor:formalColor}};">
								{{ scope.row.status==0?'草稿':'正式'}}</span>
							</template>	
						</el-table-column>
				<!-- 		<el-table-column label="项目状态" align="center">
							<template slot-scope="scope">
								<span :style="margin-left: 10px;">{{ scope.row.status}}</span>
							</template>
						</el-table-column> -->
						<el-table-column label="操作" align="center">
							<template slot-scope="scope">
								<el-button size="mini" @click="editBsns(scope.$index, scope.row)">编辑</el-button>
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
 					<el-form-item label="流程描述：" prop="stepDesc" >
   						<el-input placeholder="请输入流程名" v-model="stepForm.stepDesc" style="width: 80%;" clearable>
 					</el-form-item>
 					<el-form-item label="优先级：" prop="priority" >
   						<el-input placeholder="请输入优先级" v-model.number="stepForm.priority" style="width: 80%;" clearable>
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
					<el-button type="primary" @click="addStep('stepForm','stepModalVisible')">确 认</el-button>
				</span>
  			</el-dialog>
  			<el-form :model="bsnsForm"  :rules="bsnsRules"  status-icon ref="bsnsForm" label="top">
				<el-form-item label="项目名：" prop="bsnsName"  >
   					<el-input placeholder="请输入项目名" v-model="bsnsForm.bsnsName" style="width: 80%;" clearable>
 				</el-form-item>
 				<el-form-item label="项目描述：" >
   					<el-input placeholder="请输入项目描述" v-model="bsnsForm.bsnsDesc" style="width: 80%;" clearable>
 				</el-form-item>
 				<!--bug  step放在item下 step线的位置会变 -->
 				<el-form-item label="审批流程：" >
  				</el-form-item>
 				<el-steps  :active="0">
					<el-step :title="step.stepName" :description="step.stepDesc" v-for="step in bsnsForm.steps"></el-step>
				</el-steps>
				<el-button type="primary" size="mini" icon="el-icon-plus" @click="stepModalVisible = true"></el-button>
  			</el-form>
			<span slot="footer">
				<el-button @click="hideModal('bsnsForm','addBsnsVsb')">取 消</el-button>
    			<el-button type="primary" @click="addBsns('bsnsForm')">确 认</el-button>
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
				bsnsDesc:null,
				steps:[],
			},
			stepForm:{
				//step属性
				stepName:'',
				stepDesc:null,
				priority:'',

				sltRole:'',
				sltUser:'',
				users:[],
				addStep:'',
			},
			bsnsRules:{
				bsnsName:[{ required: true, message: '项目名不能为空'},
						{validator: checkBsnsName, trigger: 'blur' }],
			},
			stepRules:{
				stepName:[  { required: true, message: '流程名不能为空'},],
				priority:[{required:true,message:'优先级不能为空'},{ type: 'number', message: '优先级必须为数字值'}],
				sltRole:[{required:true,message:'审批角色不能为空'}]
			},
			bsnsList: [], //table 数据
			addBsnsVsb:false,   //添加modal
			sltUserVsb:false,  //审批用户下拉框vsb
			stepModalVisible:false,//审批流程modal vsb
			
			draftColor:'#909399',//草稿状态字体颜色
			formalColor:'#67C23A',//正式状态字体颜色
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
		editBsns:function(index,row){
			// bsnsForm:{
			// 	bsnsName:'',
			// 	bsnsDesc:null,
			// 	steps:[],
			// },
			this.bsnsForm.bsnsName = row.businessName;
			this.bsnsForm.bsnsDesc = row.businessDesc;
			this.bsnsForm.steps = row.businessDesc;
			this.addBsnsVsb = true;
			modalOperating = 1;
			sltBusiness = row;
		},
		deleteBsns:function(index,row){
			row.cfmVisible = false;
			var data = {"businessId":row.businessId};
			$.ajax({
			url:"deleteBusiness",
			data:data,
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
			}
		});
		},
		batchDelete:function(){
			var ids = new Array;
			for(var row of this.multipleSelection){
				ids.push(row.businessId);
			}
			var data = {"businessIds":ids};
			$.ajax({
			url:"batchDltBsns",
			data:data,
			type:"get",
			traditional: true,//传递数组
			success:function(data){
				if(data==0){
					toastr.error("全部删除失败");
				}else if(data==1){
					toastr.success("部分删除成功");
				}else{
					toastr.success("全部删除成功");
				}
				loadTableData();
			},
			error:function(){
				toastr.error("请求失败");
			}
		});
		},
		addStep:function(formName,visible){
			this.$refs[formName].validate((valid) =>{
				if(valid){
					this.stepModalVisible = false;
					if(this.bsnsForm.steps.length<stepMaxCount){
						this.stepForm.addStep = {"stepName":this.stepForm.stepName,"approvalRoleId":this.stepForm.sltRole.roleId,
												"stepDesc":this.stepForm.stepDesc,"priority":this.stepForm.priority};
						if(!isnull(this.stepForm.sltUser)){
							this.stepForm.addStep.approvalUserId = this.stepForm.sltUser.userId;
						}
						this.bsnsForm.steps.push(this.stepForm.addStep);
						this.bsnsForm.steps =  _.sortBy(this.bsnsForm.steps,'priority');

						this.bsnsForm.stepRequired = 'notnull';
					}else{
						toastr.error("添加失败，超过最大值");
					}
					this.hideStepModal(formName,visible);
					return;
				}else{
					return;
				}
			});
		},
		//添加项目信息
		addBsns:function(formName){
				this.$refs[formName].validate((valid) =>{
				if(valid){
					var parameter = {"businessName":this.bsnsForm.bsnsName,"businessDesc":this.bsnsForm.bsnsDesc,"steps":this.bsnsForm.steps,
							"createTime":moment(new Date()).format("YYYY-MM-DD HH:mm:ss"),"createUserId":${user.userId},
							"updateTime":moment(new Date()).format("YYYY-MM-DD HH:mm:ss")
						};
					$.ajax(
					{
						url: "addBusiness",
						data:JSON.stringify(parameter),
						dataType:"json",  
						type: "post",
						contentType:"application/json;charset=UTF-8",
						success:function(data)
						{
							if(data>0){
								toastr.success("添加项目成功");
								vue.hideModal('bsnsForm','addBsnsVsb');
								loadTableData();
							}else{
								if(vue.bsnsForm.steps.length==0){
									toastr.error("添加失败,审批流程不能为空");
								}else{
									toastr.error("添加项目失败");
								}
								
							}
						},
						error:function()
						{
							toastr.error("请求失败");
						},
					});
				}else{
					return;
				}
			});
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
//加载table数据
function loadTableData(){
	$.ajax({
			url:"businessList",
			dataType:"json",  
			type:"get",
        	traditional: true,//传递数组
        	success:function(data){
        		//todo 修改modal 替换成kong
        		var list = [];
        		for(var bsns of data){
        			bsns.createTime = moment(bsns.createTime).format("YYYY-MM-DD  HH:mm:ss");
        			bsns.updateTime = moment(bsns.updateTime).format("YYYY-MM-DD  HH:mm:ss");
        			if(isnull(bsns.businessDesc)){
        				bsns.businessDesc = "暂无数据";
        			}
        			//bsns.status = bsns.status==0?'草稿':'正式';
        			list.push(bsns);
        		}
        		vue.bsnsList = list;
        	},
        	error:function(){
        		toastr.error("请求失败");
        	},
   		 });
};
});
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