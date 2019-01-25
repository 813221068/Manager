<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>业务申报审批系统 - 角色管理</title>
	
	<%@ include file="common.jsp"%>
</head>
<body class="full-layout gray-bg" >
	<jsp:include page="navbar.jsp"></jsp:include>
	<jsp:include page="header.jsp"></jsp:include>
	<div class="content" id="content">
		<div>
			<h2>角色列表</h2>
			<p>所有角色具体信息</p>
		</div>
		<div class="table-bg">
			<div>
				<p>悬浮可查看更多信息</p>
			</div>
            <div id="toolbar" class="btn-group">
                <button type="button" class="btn btn-primary m-r" data-toggle="modal" data-target="#addRoleModal" data-backdrop="static" id="addButton">
                    <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>新增角色
                </button>
                <button id="batchDelete" type="button" class="ant-btn display" onclick="batchDelete()">
                    <span><i class="fa fa-trash-o" aria-hidden="true"></i></span>批量删除
                </button>
            </div>
			<div class = "table">
				<table id="roleList" >
				</table>	
			</div>
		</div>
	</div>
	<jsp:include page="footer.jsp"></jsp:include>
    <form class="form-horizontal" role="form" id="addForm">
    <div class="modal fade" id="addRoleModal" tabindex="-1" role="dialog" aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 class="modal-title" >
                        角色
                    </h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form" id="roleForm">
                        <div class="form-group required text-center">
                            <label for="roleName" class="col-sm-3 control-label">角色名</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" id="roleName" name="roleName" 
                                placeholder="请输入角色名" oninput="checkRoleName()">
                            </div>
                            <div class="display msg" id="msgRoleName">请输入长度至少为3的角色名</div>
                        </div>
                        <div class="form-group">
                            <label for="desc" class="col-sm-3 control-label">角色描述</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" name="desc" id="desc"
                                       placeholder="请输入角色描述">
                            </div>
                        </div>
                        <div class="form-group required">
                            <label for="rolePms" class="col-sm-3 control-label">角色权限</label>
                            <div class="col-sm-9">
								<select class="form-group selectpicker" title="请选择角色权限" multiple id="pmsSelect">
									<option value="1">广东省</option>
									<option value="2">广西省</option>
									<option value="3">福建省</option>
									<option value="4">湖南省</option>
								</select>
							</div>
						</div>
                        <input type="hidden" id="createTime" name="createTime">
                        <input type="hidden" id="lastUpdateTime" name="lastUpdateTime">
                        <input type="hidden" id="createUId" name="createUId">
                        <input type="hidden" id="pmsList" name="pmsList">
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
var allPmsList; //所有权限
var modalOperating = 0 // modal操作标识 0是添加  1是修改
var updateRoleId = 0;
//table操作事件
window.operateEvents = {
	//修改操作
    'click #tableEdit':function(e,value,row,index){
        // console.log(row);
        $('#addRoleModal').modal('show');
        var pmsIds = new Array;
        for(var pms of row.pmsList){
            pmsIds.push(pms.permissionId);
        }
        var pmsSelectIds = new Array;
        for(var i in allPmsList){
            if(_.indexOf(pmsIds,allPmsList[i].permissionId) != -1){
                pmsSelectIds.push(Number(i)+Number(1));
            }
        }
        document.getElementById('roleName').value = row.roleName;
        document.getElementById('desc').value = row.desc;
        $("#pmsSelect").val(pmsSelectIds).trigger('change');
        $('#pmsSelect').selectpicker('val', pmsSelectIds);
        modalOperating = 1;
        updateRoleId = row.roleId;
    },
    //删除操作
    'click #tableDelete':function(e,value,row,index){
        $.ajax({
            url:"deleteRole",
            data:{"roleId":row.roleId},
            type:"get",
            success:function(data){
                if(data==0){
                    toastr.error("删除失败");
                }else{
                    toastr.success("删除成功");
                }
                $('#roleList').bootstrapTable('refresh');
                
            },
            error:function(){
                toastr.error("删除失败");
            },
        });
    }
};
$(document).ready(function () {
    //加载table数据
    $('#roleList').bootstrapTable({
        url: "getRoleList",                      
        method: 'GET',                    
        toolbar: '#toolbar',             
        striped: true,                      
        cache: false,                      
        pagination: true,                  
        sortable: true,                   
        sortOrder: "asc",                   
        sidePagination: "client",          
        pageNumber: 1,                    
        pageSize: 10,                     
        pageList: [ 5,10, 20, 50],       
        search: false,                      
        strictSearch: true,
        showColumns: true,                  
        showRefresh: true,                 
        minimumCountColumns: 2,           
        clickToSelect: false,             
        //height: 500,                     
        uniqueId: "roleId",                   
        showToggle: true,                   
        cardView: false,                 
        detailView: false,                
//          queryParams : function (params) {
//             var temp = {   
/*                 rows: params.limit,                        
                page: (params.offset / params.limit) + 1,   
                sort: params.sort,      
                sortOrder: params.order 
            };
            return temp;
        },  */
        columns: [
            {
            checkbox: true,  
            visible: true                  
        },  
        {
            field: 'roleId',
            title: "角色ID",
            sortable: true
        }, {
            field: 'roleName',
            title: "角色名",
    //        sortable: true
        }, {
            field: 'desc',
            title: "描述",
    //        sortable: true,
        }, {
            field: 'createUser',
            title: '创建人',
            formatter: function (value, row, index) {
                if(isnull(value)){
                    return value;
                }
                var str = '<div class="table-td">'+value.username+'<span class="tooltiptext">'
                    +'用户ID:'+value.userId+'<br>用户名:'+value.username+'</span></div>';
                return str;
            }
        }, {
            field: 'createTime',
            title: '创建时间',
            sortable:true,
            formatter: function (value, row, index) {
                var date = moment(value);
                var str = '<i class="fa fa-clock-o" aria-hidden="true"></i><span> </span>';
                return str+moment(date).format("YYYY-MM-D  HH:mm:ss");
            }
        }, {
            field: 'lastUpdateTime',
            title: '更新时间',
            sortable:true,
            formatter: function (value, row, index) {
                var date = moment(value);
                var str = '<i class="fa fa-clock-o" aria-hidden="true"></i><span> </span>';
                return str+moment(date).format("YYYY-MM-D  HH:mm:ss");
            }
        }, 
        {
            field: 'owners',
            title: '所属用户',
            formatter: function (value, row, index) {
                if(_.size(value)==0){
                    return "-";
                }
                var first = _.first(value);
                var str = '<div class="table-td">'+first.username+'<span class="tooltiptext">';
                for(var i in value){
                    if(i>=3){
                        str +='....';
                        break;
                    }
                    str += value[i].username+'<br>';
                }
                str +='</span></div>'; 
                return str;
            }
        }, 
         {
            field: 'pmsList',
            title: '拥有权限',
            formatter: function (value, row, index) {
                if(_.size(value)==0){
                    return "-";
                }
                var first = _.first(value);
                var str = '<div class="table-td">'+first.permissionName+'<span class="tooltiptext">';
                for(var i in value){
                    if(i>=3){
                        str +='....';
                        break;
                    }
                    str += value[i].permissionName+'<br>';
                }
                str +='</span></div>'; 
                return str;
            }
        }, 
         {
            field:'button',
            title: '操作',
            align: 'center',
            valign: 'middle',
            formatter: actionFormatter,
            events:operateEvents
        }, 
        ],
        onLoadSuccess: function () {
           
        },
        onLoadError: function () {
            alert("数据加载失败");
        },
        onCheckAll:function(rows){
            console.log(rows);    
        },
        onPostBody:function(){
            //引入icheck样式  todo 修改dropmenu的checkbox
            $('.bs-checkbox').iCheck({
                checkboxClass : 'icheckbox_square-green',
                radioClass : 'iradio_square-green',
            });
            $('.card-view').iCheck({
                checkboxClass : 'icheckbox_square-green',
                radioClass : 'iradio_square-green',
            });
            //全选
             $("th.bs-checkbox").on('ifChecked',function(event){
                 $('.bs-checkbox').iCheck('check');
             });
             //反选
            $("th.bs-checkbox").on('ifUnchecked',function(event){
                $('.bs-checkbox').iCheck('uncheck');
            });
            //table模式下批量删除按钮
            $('.bs-checkbox').on('ifChanged',function(){
                if($('.bs-checkbox input:checked').length>0){
                    document.getElementById('batchDelete').style.display = "inline";
                }else{
                    document.getElementById('batchDelete').style.display = "none";
                }
            });
            //card模式下批量删除
            $('.card-view').on('ifChanged',function(){
                 if($('.card-view input:checked').length>0){
                    document.getElementById('batchDelete').style.display = "inline";
                }else{
                    document.getElementById('batchDelete').style.display = "none";
                }
            });
            

        },
/*         onDblClickRow: function (row, $element) {
            var id = row.ID;
           alert("click");
        }, */
    });
    //获取权限列表
 	$.ajax(
			{
				url: "getPmsList",
           //     data:,
                type: "post",
                success:function(data)
                {
	             	var slt = document.getElementById("pmsSelect");
	             	allPmsList = data;
	             	slt.options.length = 0;
	             	for(var pms of data){
	             	//	console.log(pms);
	             		var label = document.createElement("lable");
	             		label.setAttribute("class","label label-info");
	             		var opt = document.createElement("span");
	             //		opt.setAttribute("data-content",label);
	             		opt.setAttribute("text",pms.permissionName);
	             		opt.setAttribute("value",pms.permissionName);
	             		opt.setAttribute("id",pms.permissionId);
	             		slt.options.add(new Option(pms.permissionName,pms.permissionId));
	             		
	             	}
	                 $('#pmsSelect').selectpicker('refresh');  
       				 $('#pmsSelect').selectpicker('render');  
                },
            }); 

});


//批量删除
function batchDelete(){
    var table = $('#roleList').bootstrapTable('getData');
    var rows = document.getElementById('roleList').rows;
    var ids = new Array;
    for(var i=1;i<=rows.length;i++){
        if($(rows[i]).find('input:checked').length>0){
            ids.push(table[i-1].roleId);
        }
    }
    $.ajax({
        url:"deleteRole",
        data:{"roleIds":ids},
        type:"get",
        traditional: true,//传递数组
        success:function(data){
            if(data==0){
                toastr.error("删除失败");
            }else{
                toastr.success("删除成功");
            }
            $('#roleList').bootstrapTable('refresh');
            
        },
        error:function(){
            toastr.error("删除失败");
        },
    });
    
    document.getElementById('batchDelete').style.display = 'none';
};
//检查角色名输入是否合法
function checkRoleName(){
	var roleName = document.getElementById("roleName").value;
	if(isnull(roleName)){
		return false;
	}
	if(roleName.length<3){
		document.getElementById("roleName").className = "has-error form-control";
		document.getElementById("msgRoleName").style.display = "inline";
		return false;
	}else{
		document.getElementById("roleName").className = "form-control";
		document.getElementById("msgRoleName").style.display = "none";
		return true;
	}
};
//modal确认事件
function modalOnclick(){
    if(!checkRoleName()){
        var txt = "请输入至少长度为3的角色名"
        window.wxc.xcConfirm(txt, window.wxc.xcConfirm.typeEnum.info);
        return false;
    }

    var pmsIds = $("#pmsSelect").val();
    if(isnull(pmsIds)){
        var txt = "请选择角色权限"
        window.wxc.xcConfirm(txt, window.wxc.xcConfirm.typeEnum.info);
        return false;
    }
    var list = new Array();
    for(var i in allPmsList){
        if(_.indexOf(pmsIds, (Number(i)+Number(1)).toString())!=-1){
            list.push(allPmsList[i]);
        }
    }
    var data = {};
    data.roleName = document.getElementById("roleName").value;
    data.desc = document.getElementById("desc").value;
    data.createTime = moment().format("YYYY-MM-DD HH:mm:ss");
    data.lastUpdateTime = moment().format("YYYY-MM-DD HH:mm:ss");
    data.createUId =  "${user.userId}";
    data.pmsList = list;
    var dataJsonStr = JSON.stringify(data);
    if(modalOperating==1){
        modalOperating = 0;
        return updateRole(data);
    }else{
        return addRole(data);
    }
};
function updateRole(data){
    data.roleId = updateRoleId;
    updateRoleId = 0;
    console.log(data);
    var updateResult = 0;
    $.ajax(
        {
            url: "updateRole",
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
                alert('请求失败');
            },
            complete:function()
            {
                $('#addRoleModal').modal('hide');
                $("#roleList").bootstrapTable('refresh');
                if(updateResult>0){
                    toastr.success("修改角色信息成功");
                }
                else if(updateResult==0){
                    toastr.error("修改角色信息失败");
                } 
            //  $('.modal-backdrop').remove();
            }
        });
    return false;
};
function addRole(data) {
    var addResult = 0;
    $.ajax(
        {
            url: "addRole",
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
                alert('请求失败');
            },
            complete:function()
            {
                $('#addRoleModal').modal('hide');
                $("#roleList").bootstrapTable('refresh');
                if(addResult>0){
                    toastr.success("添加角色成功");
                }
                else if(addResult==0){
                    toastr.error("添加角色失败");
                } 
            //  $('.modal-backdrop').remove();
            }
        });

    return false;
};
$('#addRoleModal').on('hide.bs.modal', function () {
	$("input[type=reset]").trigger("click");
	$('#pmsSelect').selectpicker('refresh');  
	$('#pmsSelect').selectpicker('render'); 
   
});
$('#addRoleModal').on('hidden.bs.modal',function(){
});
window.onload = function() {
    /* 角色权限*/
<%--    var userId = ${user.userId};
    $.ajax({
        type : 'post',
        url : "../getPmsList",
        dataType : 'json',
        data : {"userId" : userId},
        success : function(pmsList) {
            var pmsAll =<%=session.getAttribute("pmsAll")%>;
            
                for ( var i in pmsAll) {
                    var pms = pmsAll[i];
                    if (isnull(_.find(pmsList, pms))) {
                        console.log(pms.permissionName);
                        document.getElementById(pms.permissionName).style.display = "none";
                    }
                }
            }
    }); --%>

};
</script>
</html>