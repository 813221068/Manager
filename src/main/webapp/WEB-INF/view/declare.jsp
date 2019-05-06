<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>业务申报审批系统 - 业务列表</title>
	
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
                               <el-button @click="downloadFile(scope.$index, scope.row)" type="text">{{scope.row.fileName}}</el-button>
                            </template>
                        </el-table-column>
                        <el-table-column label="操作" align="center">
                            <template slot-scope="scope">
                                <el-button v-if="!scope.row.declare" size="mini" type="primary"  @click="declareBtnClick(scope.row)">申报</el-button>
                                <el-button v-if="scope.row.declare" size="mini" type="success"  @click="progressBtnClick(scope.row)">审批进度</el-button>
                            </template>
                        </el-table-column>
                </el-table>
                <div class="m-t">
                    <el-pagination background layout="total, sizes, prev, pager, next, jumper" :total="total" :page-sizes="[5, 10, 20, 50]" :page-size="pageSize"  @size-change="pageSizeChange" @current-change="currentPageChange">
                    </el-pagination>
                </div>
            </div>
		</div>
        <el-dialog :visible.sync="declareVsb" title="上传申报资料" :append-to-body="true"  :modal-append-to-body='false' 
        width="20%" :close-on-click-modal="false">
            <el-upload ref="upload" action="doDeclare" :auto-upload="false"  :before-remove="beforeRemove" :data="declareBsns"
            :limit="1" :on-exceed="handleExceed" :on-change="onChange" accept="text/plain">
                <el-button slot="trigger" size="small" type="primary">选择申报资料</el-button>
                <div slot="tip" class="el-upload__tip">只能上传txt文件，且不超过500kb</div>
            </el-upload>
            <span slot="footer">
                <el-button @click="hideDialog()">取 消</el-button>
                <el-button style="margin-left: 10px;" type="success" @click="submitUpload" plain>确认</el-button>
            </span>
            
        </el-dialog>
        <el-dialog :visible.sync="progressVsb" title="申报进度" :append-to-body="true"  :modal-append-to-body='false' 
        width="20%" :close-on-click-modal="false">
            <el-steps >
                <el-step :status="step.status" :title="step.statusDesc" :description="step.stepName" v-for="step in steps" ></el-step>
            </el-steps>
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
                declareVsb:false,//是否展示申报页面
                progressVsb:false,//是否显示申报进度页面
                steps:null,//用户申报业务的审批流程
                bsnsList:[],
                search:{
                    bsnsName:null,
                    sltStatus:"",
                },
                declareBsns:{
                    declareUserId:null,
                    businessId:null,
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
                    this.uploadFiles();
                    // this.$refs.upload.submit();
                }
                
                // this.hideDialog();
            },
            //下载申报要求文件
            downloadFile:function(index,row){
                var form = $("<form>");
                form.attr("style","display:none");
                form.attr("target","");
                form.attr("method","post");
                form.attr("action",  "downloadFile");
                var bsnsIDIpt = $("<input>");
                bsnsIDIpt.attr("type","hidden");
                bsnsIDIpt.attr("name","path");
                bsnsIDIpt.attr("value","upload");
                var realFileNameIpt = $("<input>");
                realFileNameIpt.attr("type","hidden");
                realFileNameIpt.attr("name","realFileName");
                realFileNameIpt.attr("value",row.fileName);
                var downloadFileNameIpt = $("<input>");
                downloadFileNameIpt.attr("type","hidden");
                downloadFileNameIpt.attr("name","fileName");
                downloadFileNameIpt.attr("value",row.businessId);
                $("body").append(form);
                form.append(bsnsIDIpt);
                form.append(downloadFileNameIpt);
                form.append(realFileNameIpt);
                form.submit();
                form.remove();
            },
            beforeRemove(file, fileList) {
                return this.$confirm('确定移除 ${ file.name }？');
            },
            uploadFiles(){
                var file = this.$refs.upload.uploadFiles[0];
                var form = new FormData();
                form.append("businessId",this.declareBsns.businessId);
                form.append("declareUserId",this.declareBsns.declareUserId);
                form.append("startTime",moment(new Date()).format("YYYY-MM-DD HH:mm:ss"));
                form.append("file",file.raw);
                $.ajax({
                    processData:false,
                    contentType:false,
                    type:"post",
                    url:"doDeclare",
                    data:form,
                    success: function(data) {
                        if(data){
                            vue.$message.success('申报成功');
                            vue.hideDialog();
                            loadTableData({});
                        }
                        else{
                            vue.$message.error('申报失败');
                        }
                    },
                    error: function(error) {
                        vue.$message.error('请求失败！');
                    }
                });
            },
            hideDialog:function(){
                this.declareVsb = false;
                this.$refs.upload.clearFiles();
            },
            //超出允许文件最大数
            handleExceed:function(files, fileList){
                this.$message.warning('允许上传最大文件数为1，已超出！');
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
                    // 有闪烁
                    this.$refs.upload.uploadFiles = fileList.slice(-1);
                }
            },
            declareBtnClick:function(row){
                this.declareVsb = true;
                this.declareBsns.businessId = row.businessId;
                this.declareBsns.declareUserId = ${user.userId}; 
            },
            progressBtnClick:function(row){
               
                var para = {"businessId":row.businessId,"declareUserId":${user.userId}};
                $.ajax({
                    url:"getDclSteps",
                    data:JSON.stringify(para),
                    dataType:"json",  
                    type:"post",
                    contentType:"application/json;charset=UTF-8",
                    traditional: true,//传递数组
                    success:function(data){
                        var list = [];
                        var status = ["wait","process","error","success"];
                        var statusDesc = ["等待中","审核中","不通过","审核通过"];
                        for(var step of data){
                            step.statusDesc = statusDesc[step.status];
                            step.status = status[step.status];
                            list.push(step);
                        }

                        vue.steps = list;
                        // console.log(vue.steps);
                        vue.progressVsb = true;
                    },
                    error:function(){
                        toastr.error("请求失败");
                    },
                });
            },
        },
    });
    function loadTableData(para){
        //状态为正式
        para.status = 2;
        $.ajax({
            url:"getDclBsnsList",
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