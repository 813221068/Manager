<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>业务申报审批系统 - 项目管理</title>
	
	<%@ include file="common.jsp"%>
</head>
<body class="full-layout gray-bg" >
	<jsp:include page="navbar.jsp"></jsp:include>
	<jsp:include page="header.jsp"></jsp:include>
	<div class="content" id="content">
		<div class="m-t m-l m-b">
			<el-breadcrumb separator="/">
				<el-breadcrumb-item ><a href="index">首页</a></el-breadcrumb-item>
				<el-breadcrumb-item>项目管理</el-breadcrumb-item>
				<el-breadcrumb-item>项目列表</el-breadcrumb-item>
			</el-breadcrumb>
		</div>
		<div class="table-bg">
            <div id="toolbar" class="btn-group table-tool">
                <el-button type="primary" icon="el-icon-plus" size="medium"  @click="bsnsModalVsb = true">添加</el-button>
                <span class="display" id="batchBtn">
					<el-button icon="el-icon-delete" size="medium"  @click="batchDelete()">批量删除</el-button>
                </span>
            </div>
            <div class="table-search">
				<el-input  placeholder="请输入项目名" clearable suffix-icon="el-icon-search" v-model="search.bsnsName" style="width: 20%;">
				</el-input>
				<el-select  v-model="search.sltStatus" placeholder="状态选择" clearable style="margin-left: 20px;"> 
					<el-option v-for=" status in statusList" :key="status.value" :value="status.value" :label="status.label">
					</el-option>
				</el-select>
				<el-button type="primary" plain style="margin-left: 20px;" @click="submitSearch()">查找</el-button>
				<el-button type="info" plain style="margin-left: 20px;" @click="resetSearch()">重置</el-button>
            </div>
			<div class = "table">
			<!-- tableData -->
				<el-table :data="bsnsList.slice((currentPage-1)*pageSize,currentPage*pageSize)" @selection-change="checkBoxChange" 
				:default-sort = "{prop: 'businessId', order: 'ascending'}"  border stripe>
						<el-table-column type="selection" >
						</el-table-column >
						<el-table-column label="项目ID" align='center' prop="businessId" sortable>
							<template slot-scope="scope">
								<span style="margin-left: 10px">{{ scope.row.businessId }}</span>
							</template>
						</el-table-column>
						<el-table-column label="项目名称" align="center" > 
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
						<el-table-column label="状态" align="center" sortable prop="status">
							<template slot-scope="scope">
								<el-tag size="medium" :type="scope.row.status==1?'danger':'success'">
								{{ scope.row.status==1?'草稿':'正式'}}</el-tag>
						<!-- 		<span v-bind:style="{color:scope.row.status==0?draftColor:formalColor}">
								{{ scope.row.status==0?'草稿':'正式'}}</span> -->
							</template>	
						</el-table-column>
						<el-table-column label="操作" align="center">
							<template slot-scope="scope">
								<el-button v-if="scope.row.status==1?true:false" type="danger" size="mini" 
								@click="submit2Formal(scope.$index,scope.row)">提交为正式</el-button>
								<el-button v-if="scope.row.status==2?true:false" size="mini" @click="showBsns(scope.$index, scope.row)">查看</el-button>
								<el-button v-if="scope.row.status==1?true:false" size="mini" @click="editBsns(scope.$index, scope.row)">编辑</el-button>
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
					<div class="m-t">
						<el-pagination background layout="total, sizes, prev, pager, next, jumper" :total="total" :page-sizes="[5, 10, 20, 50]" :page-size="pageSize"  @size-change="pageSizeChange" @current-change="currentPageChange">
						</el-pagination>
					</div>
					
			</div>
		</div>
		<el-dialog :visible.sync="bsnsModalVsb" title="项目信息" :append-to-body="true"  :modal-append-to-body='false' width="20%" :close-on-click-modal="false">
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
 					<el-form-item label="审批用户:" v-if="sltUserVsb" v-model="defaultSltUser">
						<el-select v-model="stepForm.sltUser" value-key="userId" placeholder="选择审批用户" clearable>
 							<el-option v-for="user in stepForm.users" :key="user.userId" :value="user" :label="user.username"></el-option>
 						</el-select>
 					</el-form-item>
				</el-form>
				<span slot="footer">
					<el-button @click="hideStepModal()">取 消</el-button>
					<el-button type="primary" @click="addStep('stepForm','stepModalVisible')">确 认</el-button>
				</span>
  			</el-dialog>
  			<el-form :model="bsnsForm" ref="bsnsForm"  :rules="bsnsRules"  status-icon ref="bsnsForm" label="top">
				<el-form-item label="项目名：" prop="bsnsName"  >
   					<el-input placeholder="请输入项目名" v-model="bsnsForm.bsnsName" style="width: 80%;" clearable :disabled="cmfDisabled">
 				</el-form-item>
 				<el-form-item label="项目描述：" prop="bsnsDesc" >
   					<el-input placeholder="请输入项目描述" v-model="bsnsForm.bsnsDesc" style="width: 80%;" clearable :disabled="cmfDisabled">
 				</el-form-item>
 				<!--bug  step放在item下 step线的位置会变 -->
 				<el-form-item label="审批流程：" prop="steps">
  				</el-form-item>
 				<el-steps  :active="0" >
					<el-step :title="step.stepName" :description="step.stepDesc" v-for="step in bsnsForm.steps" ></el-step>
				</el-steps>
				<el-button type="primary" size="mini" icon="el-icon-plus" @click="stepModalVisible = true" :disabled="cmfDisabled">添加流程</el-button>
				<el-button type="primary" size="mini" icon="el-icon-delete" @click="deleteStep()" :disabled="cmfDisabled">删除流程</el-button>
  			</el-form>
			<span slot="footer">
				<el-button @click="hideBsnsModal()">取 消</el-button>
    			<el-button type="primary" @click="submitBsnsModal('bsnsForm')" :disabled="cmfDisabled">确 认</el-button>
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
//标记选中的row 
var sltBusiness = {};  
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
			total:100,//table总数
			pageSize:5,//每页条数
			currentPage:1,//当前页
			search:{
				bsnsName:null,
				sltStatus:"",
			},
			statusList:[{
				"value":1,
				"label":"草稿"
			},{
				"value":2,
				"label":"正式"
			}],
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
			bsnsModalVsb:false,   //项目modal
			sltUserVsb:false,  //审批用户下拉框vsb
			stepModalVisible:false,//审批流程modal vsb
			defaultSltUser:'',//用于清空审批用户下拉框
			draftColor:'#F56C6C',//草稿状态字体颜色
			formalColor:'#67C23A',//正式状态字体颜色
			roles:[],
			cmfDisabled:false,//查看时 禁用按钮

		};
	},
	watch:{
		sltUserVsb:function(){
			this.defaultSltUser = null;
		},
	},
	mounted:function(){
		loadTableData({});
		$.ajax({
			url:"getRoleList",
			data:JSON.stringify({}),
			type:"post",
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
		submitSearch:function(){
			var para = {"businessName":this.search.bsnsName,"status":this.search.sltStatus};
			loadTableData(para);
		},
		resetSearch:function(){
			this.search = cleanParams(this.search);
			loadTableData({});
		},
		pageSizeChange:function(val){
			this.pageSize = val;
		},
		currentPageChange:function(val){
			this.currentPage = val;
		},
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
			this.bsnsForm.bsnsName = row.businessName;
			this.bsnsForm.bsnsDesc = row.businessDesc;
			this.bsnsForm.steps = row.steps;
			this.bsnsModalVsb = true;
			modalOperating = 1;
			sltBusiness = row;
		},
		//查看
		showBsns:function(index,row){
			//todo 
			//和编辑界面一样  但是按钮禁用
			this.bsnsForm.bsnsName = row.businessName;
			this.bsnsForm.bsnsDesc = row.businessDesc;
			this.bsnsForm.steps = row.steps;

			this.cmfDisabled = true;
			this.bsnsModalVsb = true;

		},
		//提交到正式
		submit2Formal:function(index,row){
			var para = {"businessId":row.businessId,"status":2};
			var msg = [];
			msg.push('提交为正式成功');
			msg.push('提交为正式失败');
			updateBsns(para,msg);
			loadTableData({});

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
				loadTableData({});
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
				loadTableData({});
			},
			error:function(){
				toastr.error("请求失败");
			}
		});
		},
		addStep:function(formName,visible){
			this.$refs[formName].validate((valid) =>{
				if(valid){
					if(this.bsnsForm.steps.length<stepMaxCount){
						this.stepForm.addStep = {"stepName":this.stepForm.stepName,"approvalRoleId":this.stepForm.sltRole.roleId,
												"stepDesc":this.stepForm.stepDesc,"priority":this.stepForm.priority
												};
											//	"approvalUserId":0
						if(!isnull(this.stepForm.sltUser)){
							this.stepForm.addStep.approvalUserId = this.stepForm.sltUser.userId;
						}
						this.bsnsForm.steps.push(this.stepForm.addStep);
						this.bsnsForm.steps =  _.sortBy(this.bsnsForm.steps,'priority');

						this.bsnsForm.stepRequired = 'notnull';
					}else{
						toastr.error("添加失败，超过最大值");
					}
					this.hideStepModal();
					return;
				}else{
					return;
				}
			});
		},
		submitBsnsModal:function(formName){
				this.$refs[formName].validate((valid) =>{
				if(valid){
					//添加项目
					if(modalOperating==0){
						var parameter = {"businessName":this.bsnsForm.bsnsName,"businessDesc":this.bsnsForm.bsnsDesc,"steps":this.bsnsForm.steps,
							"createTime":moment(new Date()).format("YYYY-MM-DD HH:mm:ss"),"createUserId":${user.userId},
							"updateTime":moment(new Date()).format("YYYY-MM-DD HH:mm:ss"),"status":1
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
								// console.log(data);
								if(data>0){
									toastr.success("添加项目成功");
									vue.hideBsnsModal();
									loadTableData({});
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
					}else{  //修改项目信息
						modalOperating = 0;
						var para = {"businessName":this.bsnsForm.bsnsName,"businessDesc":this.bsnsForm.bsnsDesc,"businessId":
									sltBusiness.businessId,"steps":this.bsnsForm.steps};
						// console.log(para);
						var msg = [];
						msg.push('更新项目信息成功');
						msg.push('更新项目信息失败');
						updateBsns(para,msg);
						this.hideBsnsModal();
						loadTableData({});
					
					}
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
				//刷新select
				this.stepForm.sltUser = null;
				this.defaultSltUser = null;
			}else{
				this.sltUserVsb = false;
			}
		},
		deleteStep:function(){
			if(this.bsnsForm.steps.length==0){
				toastr.error('删除失败');
			}else{
				this.bsnsForm.steps = _.initial(this.bsnsForm.steps);
				toastr.success('删除成功');
			}
		},
		hideBsnsModal:function(){
			this.$refs['bsnsForm'].resetFields();
			this.bsnsForm = cleanParams(this.bsnsForm);
			// console.log(this.bsnsForm);
			this.bsnsModalVsb = false;
			this.cmfDisabled = false;
			this.bsnsForm.steps = [];
		//	this.hideStepModal();
		},
		hideStepModal:function(){
			this.$refs['stepForm'].resetFields();
			this.sltUserVsb = false;
			this.stepModalVisible = false;
		},

	}
});
//加载table数据
function loadTableData(para){
	$.ajax({
			url:"businessList",
			data:JSON.stringify(para),
			dataType:"json",  
			type:"post",
			contentType:"application/json;charset=UTF-8",
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
        			//bsns.status = bsns.status==1?'草稿':'正式';
        			list.push(bsns);
        		}
        		vue.bsnsList = list;
        		vue.total = list.length;
        	},
        	error:function(){
        		toastr.error("请求失败");
        	},
   		 });
};
/**
 * 更新项目接口
 * @param para 
 * @param msg  msg[0]是成功提示信息  msg[1]是失败提示信息
 * @returns
 */
function updateBsns(para,msg){
	$.ajax(
	{
		url: "updateBusiness",
		data:JSON.stringify(para),
		dataType:"json",  
		type: "post",
		contentType:"application/json;charset=UTF-8",
		success:function(data)
		{
			if(data){
				toastr.success(msg[0]);
			}else{
				toastr.error(msg[1]);
			}
		},
		error:function()
		{
			toastr.error("请求失败");
		},
	});
};
/**
 * 清空参数
 * @param datas
 * @returns
 */
function cleanParams(datas){
	var v_data ={};
	for(var a in datas){
		if (datas[a] != null && datas[a] instanceof Array) {
			v_data[a]=[];
		}else {
			v_data[a] = null;
		}
	}
	return v_data;
}

});
</script>
</html>