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
		<div class="table-bg" id="app">
            <div id="toolbar" class="btn-group table-tool">
                <el-button type="primary" icon="el-icon-plus" size="medium"  onclick="clickAddBtn()">添加</el-button>
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
	</div>
	<form class="form-horizontal" role="form" id="addForm">
    <div class="modal fade" id="businessModal" tabindex="-1" role="dialog" aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 class="modal-title" >
                        项目信息
                    </h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form" id="roleForm">
                        <div class="form-group required text-center">
                            <label for="roleName" class="col-sm-3 control-label">项目名 :</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" id="businessName" name="businessName" 
                                placeholder="请输入项目名" oninput="checkBsnName()">
                            </div>
                            <div class="display msg" id="msgBsnName">请输入长度至少为3的项目名</div>
                        </div>
                        <div class="form-group">
                            <label for="desc" class="col-sm-3 control-label">项目描述 :</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" name="businessDesc" id="businessDesc"
                                       placeholder="请输入项目描述">
                            </div>
                        </div>
						<div class="form-group required">
							<label for="desc" class="col-sm-3 control-label">审批流程 :</label>
							<div class="col-sm-9">
								<div class="steps">
									<el-steps  :active="0" >
										<el-step title="审批开始"></el-step>
										<el-step title="进行中"></el-step>
										<el-step title="步骤 3"></el-step>
									</el-steps>
								</div>
							</div>
							<el-button type="primary" size="mini" icon="el-icon-plus" @click="addDeal()"></el-button>
						</div>
						<input type="hidden" id="createTime" name="createTime">
                        <input type="hidden" id="updateTime" name="updateTime">
                        <input type="hidden" id="createUId" name="createUId">
                        <input type="reset" name="reset" style="display: none;" />
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消
                    </button>
                    <button type="button" onclick="modalOnclick()" class="btn btn-primary">确认
                    </button>
                </div>
            </div>/.modal-content
        </div>/.modal
    </div>
    </form>
	<jsp:include page="footer.jsp"></jsp:include>

</body>
<script type="text/javascript">
var modalOperating = 0; //0是添加   1是修改
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
//加载table数据
var vue = new Vue({
	el: '#app',
	data:function() {
		return {
			bsnsList: [],
		}
	},
	mounted:function(){
		loadTableData();
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
		}
	}
});
//modal加载
var modalVue = new Vue({
	el:'#addForm',
	data:function() {
		return {
		}
	},
	mounted:function(){
	},
	methods:{
		addDeal:function(){
			console.log('add');
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
//添加按钮点击事件
function clickAddBtn(){
	$('#businessModal').modal('show');
	modalOperating = 0;
};
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
            //  $('.modal-backdrop').remove();
            }
        });
    return false;
};
//检查项目名输入是否合法
function checkBsnName(){
	var bsnName = document.getElementById("businessName").value;
	if(isnull(bsnName)){
		return false;
	}
	if(bsnName.length<3){
		document.getElementById("businessName").className = "has-error form-control";
		document.getElementById("msgBsnName").style.display = "inline";
		return false;
	}else{
		document.getElementById("businessName").className = "form-control";
		document.getElementById("msgBsnName").style.display = "none";
		return true;
	}
};
//modal确认事件
function modalOnclick(){
    if(!checkBsnName()){
        var txt = "请输入至少长度为3的项目名"
        window.wxc.xcConfirm(txt, window.wxc.xcConfirm.typeEnum.info);
        return false;
    }

    var data = {};
    data.businessName = document.getElementById("businessName").value;
    data.businessDesc = document.getElementById("businessDesc").value;
    data.createTime = moment().format("YYYY-MM-DD HH:mm:ss");
    data.updateTime = moment().format("YYYY-MM-DD HH:mm:ss");
    data.createUId =  "${user.userId}";
    if(modalOperating==1){
        modalOperating = 0;
        return updateBusiness(data);
    }else{
        return addBusiness(data);
    }
};
//modal关闭 刷新
$('#businessModal').on('hidden.bs.modal',function(){
	$("input[type=reset]").trigger("click");
});
</script>
</html>