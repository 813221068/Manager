<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>业务申报审批系统 - 申报状态</title>
	
	<%@ include file="common.jsp"%>
</head>
<body class="full-layout gray-bg" >
	<jsp:include page="navbar.jsp"></jsp:include>
	<jsp:include page="header.jsp"></jsp:include>
	<div class="content" id="content">
		<div class="m-t m-l m-b">
            <el-breadcrumb separator="/">
                <el-breadcrumb-item ><a href="index">首页</a></el-breadcrumb-item>
                <el-breadcrumb-item>业务申报</el-breadcrumb-item>
                <el-breadcrumb-item>业务列表</el-breadcrumb-item>
            </el-breadcrumb>
        </div>
		<div class="table-bg">
             <div class="table-search">
                <el-input  placeholder="请输入项目名" clearable suffix-icon="el-icon-search" v-model="search.bsnsName" style="width: 20%;">
                </el-input> 
                <el-button type="primary" plain style="margin-left: 20px;" @click="submitSearch()">查找</el-button>
                <el-button type="info" plain style="margin-left: 20px;" @click="resetSearch()">重置</el-button>
            </div>
            <div class="table">
                <el-table :data="bsnsList.slice((currentPage-1)*pageSize,currentPage*pageSize)" border stripe>
                    <el-table-column label="项目ID" align='center' prop="businessId" sortable>
                            <template slot-scope="scope">
                                <span style="margin-left: 10px">{{ scope.row.businessId }}</span>
                            </template>
                        </el-table-column>
                        <el-table-column label="项目名称" align='center' prop="businessName" sortable>
                            <template slot-scope="scope">
                                <span style="margin-left: 10px">{{ scope.row.businessName }}</span>
                            </template>
                        </el-table-column>
                        <el-table-column label="项目描述" align='center' prop="businessDesc" sortable>
                            <template slot-scope="scope">
                                <span style="margin-left: 10px">{{ scope.row.businessDesc }}</span>
                            </template>
                        </el-table-column>
                        <el-table-column label="申报要求" align='center' prop="declareAsk" sortable>
                            <template slot-scope="scope">
                                <span style="margin-left: 10px">{{ scope.row.declareAsk }}</span>
                            </template>
                        </el-table-column>
                        <el-table-column label="操作" align="center">
                            <template slot-scope="scope">
                                <el-button size="mini" type="primary"  @click="declareVsb=true">申报</el-button>
                            </template>
                        </el-table-column>
                </el-table>
                <div class="m-t">
                    <el-pagination background layout="total, sizes, prev, pager, next, jumper" :total="total" :page-sizes="[5, 10, 20, 50]" :page-size="pageSize"  @size-change="pageSizeChange" @current-change="currentPageChange">
                    </el-pagination>
                </div>
            </div>
		</div>
        <el-dialog :visible.sync="declareVsb" title="上传申报资料" :append-to-body="true"  :modal-append-to-body='false' width="20%"
        :close-on-click-modal="false">
            <el-upload ref="upload" action="" :auto-upload="false"  :before-remove="beforeRemove" 
            :limit="3" :on-exceed="handleExceed" :on-change="onChange" :on-success="onSuccess" :on-error="onError">
                <el-button slot="trigger" size="small" type="primary">选择申报资料</el-button>
            </el-upload>
            <span slot="footer">
                <el-button @click="hideDialog()">取 消</el-button>
                <el-button style="margin-left: 10px;" type="success" @click="submitUpload" plain>确认</el-button>
            </span>
            
        </el-dialog>
	</div>
	<jsp:include page="footer.jsp"></jsp:include>
</body>
<script type="text/javascript">
$(document).ready(function(){
    var vue = new Vue({
        el:"#content",
        data:function(){
            return {
                total:100,//table总数
                pageSize:5,//每页条数
                currentPage:1,//当前页
                declareVsb:false,
                bsnsList:[],
                search:{
                    bsnsName:null,
                    sltStatus:"",
                },
            };
        },
        mounted:function(){
            loadTableData({});
        },
        methods:{
            submitSearch:function(){
                var para = {"businessName":this.search.bsnsName};
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
            submitUpload:function() {
                if( this.$refs.upload.uploadFiles.length == 0){
                    this.$message.error('请选择申报资料！');
                }else{
                    this.$refs.upload.submit();
                }
                
                // this.hideDialog();
            },
            beforeRemove(file, fileList) {
                return this.$confirm('确定移除 ${ file.name }？');
            },
            //上传成功时钩子
            onSuccess(response, file, fileList){
                this.hideDialog();
                this.$message.success('申报成功');
            },
            //失败时钩子
            onError(err, file, fileList){
                this.$message.error('申报失败！');
            },
            hideDialog:function(){
                this.declareVsb = false;
                this.$refs.upload.clearFiles();
            },
            //超出允许文件最大数
            handleExceed:function(files, fileList){
                this.$message.warning('允许上传最大文件数为3，已超出！');
            },
            //上传文件状态改变触发
            onChange:function(currentFile, fileList){
                var eqCount = 0;
                for(var file of fileList){
                    if(file.name == currentFile.name){
                        eqCount++;
                    }
                }
                if(eqCount>1){
                    this.$message.error('选择重名文件');
                    //bug 有闪烁
                    this.$refs.upload.uploadFiles = fileList.slice(-1);
                }
            },
        },
    });
    function loadTableData(para){
        //状态为正式
        para.status = 2;
        $.ajax({
            url:"businessList",
            data:JSON.stringify(para),
            dataType:"json",  
            type:"post",
            contentType:"application/json;charset=UTF-8",
            traditional: true,//传递数组
            success:function(data){
                var list = [];
                for(var bsns of data){
                    bsns.createTime = moment(bsns.createTime).format("YYYY-MM-DD  HH:mm:ss");
                    bsns.updateTime = moment(bsns.updateTime).format("YYYY-MM-DD  HH:mm:ss");
                    if(isnull(bsns.businessDesc)){
                        bsns.businessDesc = "暂无数据";
                    }
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
});

</script>
</html>