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
                    <el-button icon="el-icon-delete" size="medium"  @click="batchDelete()">批量删除</el-button>
                </span>
            </div>
            <div class="table">
                <el-table :data="roleList.slice((currentPage-1)*pageSize,currentPage*pageSize)"  border stripe>
                    <el-table-column type="selection" >
                    </el-table-column >
                    <el-table-column label="角色ID" align='center' prop="roleId" sortable>
                        <template slot-scope="scope">
                            <span style="margin-left: 10px">{{ scope.row.roleId }}</span>
                        </template>
                    </el-table-column>
                    <el-table-column label="角色名" align="center" > 
                        <template slot-scope="scope">
                            <span style="margin-left: 10px">{{ scope.row.roleId }}</span>
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
                   <!--  <el-table-column label="操作" align="center">
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
                    </el-table-column> -->
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
                    <el-select v-model="roleForm.sltPmsList" value-key="permissionId" placeholder="请选择角色权限" multiple   >
                        <el-option v-for="pms in roleForm.pmsList" :value="pms.permissionId" :key="pms.permissionId" :label="pms.permissionName">
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
            roleForm:{
                roleName:null,
                roleDesc:null,
                pmsList:[],
                sltPmsList:'',
                rules:{
                    roleName:[{required: true, message: '用户名不能为空'}]
                }
            },
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
                vue.roleForm.pmsList = data;
                console.log(vue.roleForm.pmsList);
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
        pageSizeChange:function(val){
            this.pageSize = val;
        },
        currentPageChange:function(val){
            this.currentPage = val;
        },
        hideModal:function(){
            this.roleModalVsb = false;
            this.$refs['roleForm'].resetFields();
        },
        submitModal:function(){
            this.$refs['roleForm'].validate((valid) =>{
                if(valid){
                    //添加
                    if(modalOperating==0){
                        var para = {"roleName":this.roleForm.roleName,"roleDesc":this.roleForm.roleDesc,"pmsList":this.roleForm.sltPmsList};
                        var msg = ['添加角色成功','添加角色信息失败'];
                        ajaxMethod('addRole',para,'get',msg);
                    }else{ //更新

                    }
                }else{
                    return;
                }
            });
        },
    }
});
//msg[0]是成功信息  msg[1]是失败信息
function ajaxMethod(url,data,type,msg){
    $.ajax({
        url: url,
        data:JSON.stringify(data),
        dataType:"json",  
        type: type,
        contentType:"application/json;charset=UTF-8",
        success:function(data)
        {
            console.log(data);
            if(data!=0){
                if(!isnull(msg)){
                    toastr.success(msg[0]);
                }
            }else{
                if(!isnull(msg)){
                    toastr.error(msg[1]);
                }
            }
        },
        error:function()
        {
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