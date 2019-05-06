<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>业务申报审批系统 - 业务审批</title>
	
	<%@ include file="common.jsp"%>
</head>
<body class="full-layout gray-bg" >
	<jsp:include page="navbar.jsp"></jsp:include>
	<jsp:include page="header.jsp"></jsp:include>
	<div class="content" id="content">
		<div class="m-t m-l m-b">
			<el-breadcrumb separator="/">
				<el-breadcrumb-item ><a href="index">首页</a></el-breadcrumb-item>
				<el-breadcrumb-item>业务审批</el-breadcrumb-item>
			</el-breadcrumb>
		</div>
		<div  class="table-bg">
			<el-tabs :stretch="true"  value="waitApprove">
				<el-tab-pane label="待审批" name="waitApprove" >
					<div  class="table">
						<el-table style="width: 100%" :data="needsAprvSteps" @expand-change="expandChange" :expand-row-keys="expands" :row-key="getRowKey">
							<el-table-column type="expand">
								<template slot-scope="props">
									<el-form label-position="ri" inline class="table-expand">
										<el-form-item label="流程编号：">
											 <span>{{ props.row.stepId }}</span>
										</el-form-item>
										<el-form-item label="流程名称：">
											 <span>{{ props.row.stepName }}</span>
										</el-form-item>
										<el-form-item label="业务编号：">
											 <span>{{ props.row.business.businessId }}</span>
										</el-form-item>
										<el-form-item label="业务名称：">
											 <span>{{ props.row.business.businessName }}</span>
										</el-form-item>
										<el-form-item label="业务描述：">
											 <span>{{ props.row.business.businessDesc }}</span>
										</el-form-item>
										<el-form-item label="申报条件：">
											 <span><el-button type="text" @click="downloadFile(props.row,1)">{{props.row.business.fileName}}</el-button></span>
										</el-form-item>
										<el-form-item label="用户编号：">
											 <span>{{ props.row.declareUser.userId }}</span>
										</el-form-item>
										<el-form-item label="用户名称：">
											 <span>{{ props.row.declareUser.username }}</span>
										</el-form-item>
										<el-form-item label="真实姓名：">
											 <span>{{ props.row.declareUser.realname }}</span>
										</el-form-item>
										<el-form-item label="邮箱地址：">
											 <span>{{ props.row.declareUser.mail }}</span>
										</el-form-item>
										<el-form-item label="申报资料：">
											<span><el-button type="text" @click="downloadFile(props.row,2)">{{props.row.dclFileName}}</el-button></span>
										</el-form-item>
										<el-form-item >
											<el-button type="primary" @click="showAprvModal(props.row)">审批</el-button>
										</el-form-item>
									</el-form>
								</template>
							</el-table-column>
							<el-table-column label="审批流程名" prop="id">
								<template slot-scope="scope">
	                                <span style="margin-left: 10px">{{ scope.row.stepName }}</span>
	                            </template>
							</el-table-column>
							<el-table-column label="所属业务名" prop="name">
								<template slot-scope="scope">
	                                <span style="margin-left: 10px">{{ scope.row.business.businessName }}</span>
	                            </template>
							</el-table-column>
							<el-table-column label="申报用户名" prop="desc"> 
								<template slot-scope="scope">
	                                <span style="margin-left: 10px">{{ scope.row.declareUser.username}}</span>
	                            </template>
							</el-table-column>
						</el-table>
					</div>
				</el-tab-pane>
				<el-tab-pane label="已审批" name="completeApproval">配置管理</el-tab-pane>
			</el-tabs>
		</div>
		<el-dialog title="审批" :visible.sync="aprvVsb" width="30%" :append-to-body="true"  :modal-append-to-body='false' >
			<el-form ref="aprlForm" :model="aprlForm" label-width="80px"  label-position="left" >
				<el-form-item label="评语">
					<el-input type="textarea" :rows="2" placeholder="请输入内容" v-model="aprlForm.comment"></el-input>
				</el-form-item>
				<el-form-item label="审核结果">
					<el-radio-group v-model="aprlForm.aprvResult">
						<el-radio :label="2">失败</el-radio>
						<el-radio :label="3">通过</el-radio>
					</el-radio-group>
				</el-form-item>
			</el-form>
			<span slot="footer">
                <el-button @click="hideAprvModal">取消</el-button>
                <el-button style="margin-left: 10px;" type="success" plain @click="submitAprvModal">确认</el-button>
            </span>
		</el-dialog>
	</div>
	<jsp:include page="footer.jsp"></jsp:include>
</body>
<style>
  .table-expand {
    font-size: 0;
  }
  .table-expand label {
    width: 140px;
    color: #99a9bf;
  }
  .table-expand .el-form-item {
    margin-right: 0;
    margin-bottom: 0;
    width: 50%;
  }
</style>
<script type="text/javascript">
$(document).ready(function(){
var vue = new Vue({
	el: '#content',
	data:function() {
		return {
			aprlForm:{
				comment:null,//评语
				aprvResult:2//结果 2是失败  3是成功
			},
			aprvVsb:false,//审批页面是否显示
			expands:[],//table展开行
			needsAprvSteps:[],//需要审批的流程
			sltStepRow:null,//选中的流程
		};
	},
	mounted:function(){
		this.loadTableData();
	},
	methods:{
		showAprvModal:function(row){
			this.aprvVsb = true;
			this.sltStepRow = row;
		},
		submitAprvModal:function(){
			var para = {"connId":this.sltStepRow.connId,"status":this.aprlForm.aprvResult,
					"comment":this.aprlForm.comment,"declareBusinessId":this.sltStepRow.declareBusinessId
			};

			console.log(para);
			$.ajax({
                url:"doApproval",
                data:JSON.stringify(para),
                dataType:"json",  
                type:"post",
                contentType:"application/json;charset=UTF-8",
                traditional: true,//传递数组
                success:function(data){
                	if(data){
                		vue.$message.success('审批成功');
                	}else{
                		vue.$message.error('审批失败');
                	}
                	vue.hideAprvModal();
                	vue.loadTableData();
                },
                error:function(){
                    toastr.error("请求失败");
                },
            });
		},
		hideAprvModal:function(){
			this.aprlForm.comment = null;
			this.aprlForm.aprvResult =1;
			this.aprvVsb = false;
		},
		//下载文件  type=1  申报要求    type=2  申报资料
	    downloadFile:function(row,filetype){
	    	// console.log(row);
            var form = $("<form>");
            form.attr("style","display:none");
            form.attr("target","");
            form.attr("method","post");
            form.attr("action",  "downloadFile");
            var bsnsIDIpt = $("<input>");
            bsnsIDIpt.attr("type","hidden");
            bsnsIDIpt.attr("name","path");
            // bsnsIDIpt.attr("value","upload");
            var realFileNameIpt = $("<input>");
            realFileNameIpt.attr("type","hidden");
            realFileNameIpt.attr("name","realFileName");
            // realFileNameIpt.attr("value",row.business.fileName);
            // console.log(row.business.fileName);
            var downloadFileNameIpt = $("<input>");
            downloadFileNameIpt.attr("type","hidden");
            downloadFileNameIpt.attr("name","fileName");
            // downloadFileNameIpt.attr("value",row.businessId+"_"+row.business.fileName);
            if(filetype==1){
	    		bsnsIDIpt.attr("value","upload");
	    		realFileNameIpt.attr("value",row.business.fileName);
	    		downloadFileNameIpt.attr("value",row.businessId);
	    	}
	    	else {
	    		bsnsIDIpt.attr("value","declareFiles");
	    		// realFileNameIpt.attr("value",row.business.fileName);
	    		downloadFileNameIpt.attr("value",row.declareUserId+"_"+row.business.businessId);
	    	}
            $("body").append(form);
            form.append(bsnsIDIpt);
            form.append(downloadFileNameIpt);
            form.append(realFileNameIpt);
            form.submit();
        },
		getRowKey(row){
			return row.stepId;
		},
		expandChange:function(row,expandedRows){
			if (expandedRows.length) {
				this.$notify.info({
					title: '提示',
					message: '点击申报条件可下载文件',
					duration:2000
				});
				this.expands = []
				if (row) {
					this.expands.push(row.stepId)
				}
			} else {
				this.expands = []
			}
			
		},
		loadTableData:function(){
			//status:1  状态为审批中
			var para = {"status":1,"approvalRoleId":${role.roleId},"approvalUserId":${user.userId}};
			$.ajax({
                url:"getAprvSteps",
                data:JSON.stringify(para),
                dataType:"json",  
                type:"post",
                contentType:"application/json;charset=UTF-8",
                traditional: true,//传递数组
                success:function(data){
                	var list = [];
                	for(var step of data){
                		list.push(step);
                	}
                	vue.needsAprvSteps = list;
                	// console.log(data);
                	// console.log(vue.needsAprvSteps);
                },
                error:function(){
                    toastr.error("请求失败");
                },
            });
		},
	}
});
});
</script>
</html>