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
		<div class="m-t m-l m-b">
            <el-breadcrumb separator="/">
                <el-breadcrumb-item ><a href="index">首页</a></el-breadcrumb-item>
                <el-breadcrumb-item>角色管理</el-breadcrumb-item>
                <el-breadcrumb-item>角色列表</el-breadcrumb-item>
            </el-breadcrumb>
        </div>
		<div class="table-bg">
            <div id="toolbar" class="btn-group table-tool">
                <el-button type="primary" icon="el-icon-plus" size="medium"  @click="roleModalVsb = true">添加</el-button>
                <span class="display" id="batchBtn">
                    <el-popover placement="top" width="160" v-model="batchCfmVsb" trigger="click">
                        <div class="text-center">
                            <p>确定删除该项目吗</p>
                            <el-button size="mini" type="text" @click="batchCfmVsb = false">取消</el-button>
                            <el-button type="primary" size="mini" @click="atchDelete()">确定</el-button>
                        </div>
                        <el-button icon="el-icon-delete" size="medium"  @click="batchCfmVsb = true">批量删除</el-button>
                    </el-popover> 
                </span>
            </div>
            <div class="table">
                <el-table :data="roleList.slice((currentPage-1)*pageSize,currentPage*pageSize)" @selection-change="checkBoxChange"
                 border stripe >
                    <el-table-column type="selection"   >
                    </el-table-column >
                    <el-table-column label="角色ID" align='center' prop="roleId" sortable>
                        <template slot-scope="scope">
                            <span style="margin-left: 10px">{{ scope.row.roleId }}</span>
                        </template>
                    </el-table-column>
                    <el-table-column label="角色名" align="center" > 
                        <template slot-scope="scope">
                            <span style="margin-left: 10px">{{ scope.row.roleName }}</span>
                        </template>
                    </el-table-column>
                    <el-table-column label="描述" align="center">
                        <template slot-scope="scope">
                            <span style="margin-left: 10px">{{ scope.row.roleDesc==null?'暂无数据':scope.row.roleDesc}}</span>
                        </template>
                    </el-table-column>
                    <el-table-column label="创建日期" align="center">
                        <template slot-scope="scope">
                            <i class="el-icon-time"></i>
                            <span style="margin-left: 10px">{{ scope.row.createTime }}</span>
                        </template>
                    </el-table-column>
                    <el-table-column label="更新日期" align="center">
                        <template slot-scope="scope">
                            <i class="el-icon-time"></i>
                            <span style="margin-left: 10px">{{ scope.row.updateTime }}</span>
                        </template>
                    </el-table-column>
                    <el-table-column label="创建人" align="center">
                        <template slot-scope="scope">
                             <el-popover trigger="hover" placement="top" v-if="scope.row.createUser!=null">
                                <p>用户ID: {{ scope.row.createUser.userId}}</p>
                                <p>用户名: {{ scope.row.createUser.username}}</p>
                                <div slot="reference" class="name-wrapper">
                                    <el-tag size="medium">{{ scope.row.createUser.username}}</el-tag>
                                </div>
                            </el-popover>
                            <span style="margin-left: 10px" v-if="scope.row.createUser==null">暂无数据</span>
                        </template> 
                    </el-table-column>
                    <el-table-column label="操作" align="center">
                        <template slot-scope="scope">
                            <el-button size="mini" @click="editRole(scope.$index,scope.row)">编辑</el-button>
                            <el-popover placement="top" width="160" v-model="scope.row.cfmVisible" trigger="click">
                                <div class="text-center">
                                    <p>确定删除该项目吗</p>
                                    <el-button size="mini" type="text" @click="scope.row.cfmVisible = false">取消</el-button>
                                    <el-button type="primary" size="mini" @click="deleteRole(scope.$index,scope.row)">确定</el-button>
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
        <el-dialog :visible.sync="roleModalVsb" title="角色信息" :append-to-body="true"  :modal-append-to-body='false' width="20%" :close-on-click-modal="false" >
            <el-form :model="roleForm" ref="roleForm" :rules="roleForm.rules" status-icon ref="roleForm" label-postion="right" 
            label-width="100px">
                <el-form-item label="角色名：" prop="roleName"  >
                    <el-input placeholder="请输入角色名" v-model="roleForm.roleName" style="width: 80%;" clearable >
                </el-form-item>
                <el-form-item label="角色描述：" prop="roleDesc" >
                    <el-input placeholder="请输入角色描述" v-model="roleForm.roleDesc" style="width: 80%;" clearable >
                </el-form-item>
                <el-form-item label="角色权限：" prop="sltPmsList">
                    <el-select v-model="roleForm.sltPmsList" value-key="pms" placeholder="请选择角色权限" multiple   >
                        <el-option v-for="pms in pmsList" :value="pms.permissionId" :key="pms.permissionId" :label="pms.permissionName">
                        </el-option>
                    </el-select>
                </el-form-item>
            </el-form>
            <span slot="footer">
                <el-button @click="hideModal()">取 消</el-button>
                <el-button type="primary" @click="submitModal()" >确 认</el-button>
            </span>
        </el-dialog>
	</div>
	<jsp:include page="footer.jsp"></jsp:include>
    
</body>
<script type="text/javascript">
//modal标志位  0是添加   1是修改
var modalOperating = 0;

$(document).ready(function () {
var vue = new Vue({
    el:"#content",
    data:function(){
        return{
            total:100,
            pageSize:5,//每页条数
            currentPage:1,//当前页
            roleList:[],
            roleModalVsb:false,
            pmsList:[],
            roleForm:{
                roleName:null,
                roleDesc:null,
                
                sltPmsList:'', //选中的权限ids
                rules:{
                    roleName:[{required: true, message: '用户名不能为空'}]
                }
            },
            sltRole:null,//选中行
            bacthBtnVsb:false,
            batchCfmVsb:false,
            multipleSelection:[],//table选中项
        };
    },
    mounted:function(){
        loadTableData({});
        //加载权限list
        $.ajax({
        url: "getPmsList",
        data:JSON.stringify({}),
        dataType:"json",  
        type: "post",
        contentType:"application/json;charset=UTF-8",
        success:function(data)
        {
            if(data!=null && data.length>0){
                vue.pmsList = data;
            }else{
                toastr.error('加载权限列表失败');
            }
        },
        error:function()
        {
            toastr.error("请求失败");
        },
    });
    },
    methods:{
        checkBoxChange:function(val){
            //todo bug 用v-if和v-show时，为true自动清空val
            this.multipleSelection = val;
            var batchBtn = document.getElementById('batchBtn');
            if(val.length>0){
                batchBtn.style.display = "inline";
            }else{
                batchBtn.style.display = "none";
            }
        },
        batchDelete:function(){
            var roleIds = [];
            for(var role of this.multipleSelection){
                roleIds.push(role.roleId);
            }
            var para = {"roleIds":roleIds};
            deleteRole(para);
        },
        pageSizeChange:function(val){
            this.pageSize = val;
        },
        currentPageChange:function(val){
            this.currentPage = val;
        },
        hideModal:function(){
            this.$refs['roleForm'].resetFields();
            this.roleForm = cleanParams(this.roleForm);
            this.roleModalVsb = false;
        },
        editRole:function(index,row){
            this.roleForm.roleName = row.roleName;
            this.roleForm.roleDesc = row.roleDesc;
            this.roleForm.sltPmsList = [];
            for(var pms of row.pmsList){
                this.roleForm.sltPmsList.push(pms.permissionId);
            }
            this.roleModalVsb = true;
            modalOperating = 1;
            this.sltRole = row;
        },
        deleteRole:function(index,row){
            row.cfmVisible = false;
            var para = {"roleId":row.roleId};
            deleteRole(para);
        },
        submitModal:function(){
            this.$refs['roleForm'].validate((valid) =>{
                if(valid){
                    //添加
                    if(modalOperating==0){
                        var pmsList = [];
                        for(var pmsId of this.roleForm.sltPmsList){
                            var pms = {"permissionId":pmsId};
                            pmsList.push(pms);
                        }
                        var para = {"roleName":this.roleForm.roleName,"roleDesc":this.roleForm.roleDesc,"pmsList":pmsList,
                        "createUId":${user.userId},"createTime":moment(new Date()).format("YYYY-MM-DD HH:mm:ss"),
                        "updateTime":moment(new Date()).format("YYYY-MM-DD HH:mm:ss")};
                        $.ajax({
                            url: 'addRole',
                            data:JSON.stringify(para),
                            dataType:"json",  
                            type: 'post',
                            contentType:"application/json;charset=UTF-8",
                            success:function(data)
                            {
                                if(data!=0){
                                    toastr.success('添加成功');
                                    loadTableData({});
                                    vue.roleModalVsb = false;

                                }else{
                                    toastr.error('添加失败');
                                }
                            },
                            error:function()
                            {
                                toastr.error("请求失败");
                            },
                        });
                    }else{ //更新
                        modalOperating = 0;

                        var oldPmsList = [];
                        var newPmsList = [];
                        for(var id of this.roleForm.sltPmsList){
                            var isAdd = true;
                            for(var pms of this.sltRole.pmsList){
                                if(pms.permissionId == id){
                                    oldPmsList.push(pms);
                                    isAdd = false;
                                    break;
                                }
                            }
                            if(isAdd){
                                var pms = {"permissionId":id};
                                newPmsList.push(pms);
                            }
                        }
                        var para = {"roleName":this.roleForm.roleName,"roleDesc":this.roleForm.roleDesc,"roleId":this.sltRole.roleId,
                                    "pmsList":oldPmsList,"updateTime":moment(new Date()).format("YYYY-MM-DD HH:mm:ss")};
                        var data = {"role":para,"addPmsList":newPmsList};
                        $.ajax({
                            url: 'updateRole',
                            data:JSON.stringify(data),
                            dataType:"json",  
                            type: 'post',
                            contentType:"application/json;charset=UTF-8",
                            success:function(data)
                            {
                                if(data!=0){
                                    toastr.success('更新成功');
                                }else{
                                    toastr.error('更新失败');
                                }
                                loadTableData({});
                                vue.roleModalVsb = false;
                            },
                            error:function()
                            {
                                toastr.error("请求失败");
                            },
                        });
                    }
                }else{
                    return;
                }
            });
        },
    }
});
function deleteRole(para){
    $.ajax({
        url:'deleteRole',
        data:para,
        traditional: true,//传递数组
        success:function(data){
            if(data!=0){
                toastr.success('删除成功');
            }else{
                toastr.error('删除失败');
            }
            loadTableData({});
        },
        error:function(){
            toastr.error("请求失败");
        },
    });
};
function loadTableData(para){
    $.ajax({
        url:"getRoleList",
        data:JSON.stringify(para),
        dataType:"json",  
        type:"post",
        contentType:"application/json;charset=UTF-8",
        traditional: true,//传递数组
        success:function(data){
            //todo 修改modal 替换成kong
            var list = [];
            for(var role of data){
                role.createTime = moment(role.createTime).format("YYYY-MM-DD  HH:mm:ss");
                role.updateTime = moment(role.updateTime).format("YYYY-MM-DD  HH:mm:ss");
                // role = nullConvert(role);
                list.push(role);
            }
            vue.roleList = list;
            vue.total = list.length;
        },
        error:function(){
            toastr.error("请求失败");
        },
    });
};
//空值转换
function nullConvert(datas){
    var data = {};
    for(var i in datas){
        if(isnull(datas[i])){
            data[i] = "暂无数据";
        }
        else if(datas[i]!=null && datas[i] instanceof Array){
            data[i] = nullConvert(datas[i]);
        }else {
            data[i] = datas[i];
        }
    }
    return data;
};
});
</script>
</html>