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
                <!-- <button type="button" class="btn btn-primary m-r" data-toggle="modal" data-target="#businessModal" data-backdrop="static" id="addButton">
                    <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>添加项目
                </button> -->
                <el-button type="primary" icon="el-icon-plus" size="medium">添加</el-button>
                <span class="display" id="batchBtn">
					<el-button icon="el-icon-delete" size="medium">批量删除</el-button>
                </span>
               <!--  <button id="batchDelete" type="button" class="ant-btn display" onclick="batchDelete()">
                    <span><i class="fa fa-trash-o" aria-hidden="true"></i></span>批量删除
                </button> -->
            </div>
			<div class = "table">
			<!-- 	<table id="businessTable" >
				</table> -->
				<el-table :data="bsnslist" border stripe @selection-change="checkBoxChange">
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
									<p>用户ID: {{ scope.row.createUser.userId }}</p>
									<p>用户名: {{ scope.row.createUser.username}}</p>
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
								<el-button size="mini" type="danger" @click="handleDelete(scope.$index, scope.row)">删除</el-button>
							</template>
						</el-table-column>
					</el-table>
			</div>
		</div>
	</div>
	<jsp:include page="footer.jsp"></jsp:include>
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
                            <label for="roleName" class="col-sm-3 control-label">项目名</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" id="businessName" name="businessName" 
                                placeholder="请输入项目名" oninput="checkBsnName()">
                            </div>
                            <div class="display msg" id="msgBsnName">请输入长度至少为3的项目名</div>
                        </div>
                        <div class="form-group">
                            <label for="desc" class="col-sm-3 control-label">项目描述</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" name="businessDesc" id="businessDesc"
                                       placeholder="请输入项目描述">
                            </div>
                        </div>
						<div class="form-group required">
							<label for="desc" class="col-sm-3 control-label">审批流程</label>
							<div class="col-sm-9">
								<input type="text" class="form-control" name="businessDesc"
									id="businessDesc" placeholder="请输入项目描述">
							</div>
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
</body>
<script type="text/javascript">
var modalOperating = 0; //0是添加   1是修改
var sltBusiness;
$(document).ready(function(){
	//table操作事件
	window.operateEvents = {
	//修改操作
    'click #tableEdit':function(e,value,row,index){
        $('#businessModal').modal('show');
        document.getElementById('businessName').value = row.businessName;
        document.getElementById('businessDesc').value = row.businessDesc;
        modalOperating = 1;
        sltBusiness = row;
    },
    //删除操作
    'click #tableDelete':function(e,value,row,index){
        $.ajax({
            url:"deleteBusiness",
            data:{"businessId":row.businessId},
            type:"get",
            success:function(data){
                if(data==0){
                    toastr.error("删除失败");
                }else{
                    toastr.success("删除成功");
                }
                $('#businessTable').bootstrapTable('refresh');
                
            },
            error:function(){
                toastr.error("删除失败");
            },
        });
    }
};
//加载table数据
var vue = new Vue({
	el: '#app',
	data:function() {
		return {
			bsnslist: []
		}
	},
	mounted:function(){
		$.ajax({
			url:"businessList",
			type:"get",
        	traditional: true,//传递数组
        	success:function(data){
        		var list = [];
        		for(var bsns of data){
        			bsns.createTime = moment(data.createTime).format("YYYY-MM-D  HH:mm:ss");
        			bsns.updateTime = moment(data.updateTime).format("YYYY-MM-D  HH:mm:ss");
        			list.push(bsns);
        		}
        		vue.bsnslist = list;
        	//	console.log(vue.bsnslist);
        	},
        	error:function(){
        		toastr.error("请求失败");
        	},
   		 });
	},
	methods:{
		checkBoxChange:function(){
			console.log($('.table input:checked'));
			var batchBtn = document.getElementById('batchBtn');
			if($('.table input:checked').length>0){
				batchBtn.style.display = "inline";
			}else{
				batchBtn.style.display = "none";
			}
			
		}
	}
});
// 	//加载table数据  bootstap-table
// 	$('#businessTable').bootstrapTable({
// 		url:'businessList',
// 		method:'get',
// 		toolbar: '#toolbar',
// 		striped: true,
// 		cache: false,
// 		pagination: true,                  
//         sortable: true,                   
//         // sortOrder: "asc",                   
//         sidePagination: "client",          
//         pageNumber: 1,                    
//         pageSize: 10,                     
//         pageList: [ 5,10, 20, 50],       
//         search: false,                      
//         strictSearch: true,
//         showColumns: true,                  
//         showRefresh: true,                 
//         minimumCountColumns: 2,           
//         clickToSelect: false,             
//         uniqueId: "businessId",                   
//         showToggle: true,                   
//         cardView: false,                 
//         detailView: false,
//         columns: [
//         {
//         	checkbox: true,  
//             visible: true 
//         },
//         {
//         	field: 'businessId',
//             title: "项目ID",
//             sortable: true
//         },
//         {
//         	field: 'businessName',
//             title: "项目名称",
//         },
//          {
//         	field: 'businessDesc',
//             title: "项目描述",
//         },
//         {
//         	field: 'createUser',
//             title: "创建人",
//             formatter: function (value, row, index) {
//                 if(isnull(value)){
//                     return value;
//                 }
//                 var str = '<div class="table-td">'+value.username+'<span class="tooltiptext">'
//                     +'用户ID:'+value.userId+'<br>用户名:'+value.username+'</span></div>';
//                 return str;
//             }
//         },
//         {
//         	field: 'createTime',
//             title: "创建时间",
//             sortable: true,
//             formatter: function (value, row, index) {
//                 var date = moment(value);
//                 var str = '<i class="fa fa-clock-o" aria-hidden="true"></i><span> </span>';
//                 return str+moment(date).format("YYYY-MM-D  HH:mm:ss");
//             }
//         },
//         {
//         	field: 'updateTime',
//             title: "更新时间",
//             sortable: true,
//             formatter: function (value, row, index) {
//                 var date = moment(value);
//                 var str = '<i class="fa fa-clock-o" aria-hidden="true"></i><span> </span>';
//                 return str+moment(date).format("YYYY-MM-D  HH:mm:ss");
//             }
//         },
// //         {
// //             field:'button',
// //             title: '操作',
// //             align: 'center',
// //             valign: 'middle',
// //             formatter: actionFormatter,
// //             events:operateEvents
// //         },  
//         ],
//         onPostBody:function(){
//             //引入icheck样式  todo 修改dropmenu的checkbox
//             $('.bs-checkbox').iCheck({
//                 checkboxClass : 'icheckbox_square-green',
//                 radioClass : 'iradio_square-green',
//             });
//             $('.card-view').iCheck({
//                 checkboxClass : 'icheckbox_square-green',
//                 radioClass : 'iradio_square-green',
//             });
//             //全选
//              $("th.bs-checkbox").on('ifChecked',function(event){
//                  $('.bs-checkbox').iCheck('check');
//              });
//              //反选
//             $("th.bs-checkbox").on('ifUnchecked',function(event){
//                 $('.bs-checkbox').iCheck('uncheck');
//             });
//             //table模式下批量删除按钮
//             $('.bs-checkbox').on('ifChanged',function(){
//                 if($('.bs-checkbox input:checked').length>0){
//                     document.getElementById('batchDelete').style.display = "inline";
//                 }else{
//                     document.getElementById('batchDelete').style.display = "none";
//                 }
//             });
//             //card模式下批量删除
//             $('.card-view').on('ifChanged',function(){
//                  if($('.card-view input:checked').length>0){
//                     document.getElementById('batchDelete').style.display = "inline";
//                 }else{
//                     document.getElementById('batchDelete').style.display = "none";
//                 }
//             });
            

//         },
// 	});

});
//批量删除
function batchDelete(){
    var table = $('#businessTable').bootstrapTable('getData');
    var rows = document.getElementById('businessTable').rows;
    var ids = new Array;
    for(var i=1;i<=rows.length;i++){
        if($(rows[i]).find('input:checked').length>0){
            ids.push(table[i-1].businessId);
        }
    }
    $.ajax({
        url:"deleteBusiness",
        data:{"businessIds":ids},
        type:"get",
        traditional: true,//传递数组
        success:function(data){
            if(data==0){
                toastr.error("删除失败");
            }else{
                toastr.success("删除成功");
            }
            $('#businessTable').bootstrapTable('refresh');
            
        },
        error:function(){
            toastr.error("删除失败");
        },
    });
    
    document.getElementById('batchDelete').style.display = 'none';
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
$('#businessModal').on('hide.bs.modal', function () {
	
});
$('#businessModal').on('hidden.bs.modal',function(){
	$("input[type=reset]").trigger("click");
});
</script>
</html>