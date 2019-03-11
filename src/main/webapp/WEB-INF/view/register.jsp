<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>

    <meta charset="utf-8">
    <title>业务申报审批系统 - 注册</title>
    <%@ include file="../view/common.jsp"%>
</head>

<body class="gray-bg register-bg">

    <div id="content" class="register-box text-center animated fadeInDown">
        <div>
            <h3>欢迎注册 </h3>
            <p>创建一个新账户</p>
            <div class="msg">${msg}</div>
            <el-form  status-icon label-postion="left" :rules="rules" :model="rgstForm" ref="rgstForm" >
                <el-form-item  prop="username"  >
                    <el-input placeholder="请输入用户名" v-model="rgstForm.username"  clearable >
                </el-form-item>
                <el-form-item  prop="mail" >
                    <el-input placeholder="请输入邮箱地址" v-model="rgstForm.mail"  clearable >
                </el-form-item>
               	<el-form-item  prop="password" >
                    <el-input type="password" placeholder="至少6位密码，区分大小写" v-model="rgstForm.password" clearable show-password>
                </el-form-item>
                <el-form-item  prop="cfmPassword" >
                    <el-input type="password" placeholder="请输入确认密码" v-model="rgstForm.cfmPassword"  clearable show-password >
                </el-form-item>
                <el-form-item class="register-form" prop="agreement">
                	<el-checkbox v-model="checked" >我已阅读并同意注册协议</el-checkbox>
                	<i class="el-icon-arrow-down" v-if="arrowVsb" @click="arrowVsb=false" ></i>
                	<i class="el-icon-arrow-up" v-if="!arrowVsb" @click="arrowVsb=true"></i>
                	<div style="margin-top: -17px;margin-bottom: -13px;">
						<a href="http://baidu.com" v-if="!arrowVsb" target="_blank" >《注册协议》</a>
                	</div>
                </el-form-item>
                <el-form-item>
					<el-button type="primary" class=" full-width" @click="register()">注册</el-button>
					<p class="text-muted text-center"><small>已经有账户了？</small><a href="login">点此登录</a>
                </el-form-item>
            </el-form>
        </div>
    </div>
    
    <div class="copyright text-center m-t">
        <p>© 2019 Border Register In Form. All rights reserved | Design by
            <a href="http://baidu.com">BlackC</a>
        </p>
    </div>
</body>
<script type="text/javascript">
$(document).ready(function(){
	var vue = new Vue({
		el:"#content",
		data:function(){
			var checkPassword = (rule, value, callback) => {
				if (value.length<6) {
					callback(new Error('密码长度不能小于6'));
				} else if(value.length>=16){
					callback(new Error('密码长度不能超过16'));
				}else{
					callback();
				}
			};
			var checkCfmPassword = (rule,value,callback) =>{
				if(value!=this.rgstForm.password){
					callback(new Error('两次输入的密码不一致！'));
				}else{
					callback();
				}
			};
			var checkAgreement = (rule,value,callback)=>{
				if(this.checked==false){
					callback(new Error('请阅读并同意注册协议'));
				}else{
					callback();
				}
			};
			return {
				rgstForm:{
					username:null,
					mail:null,
					password:null,
					cfmPassword:null,
				},
				checked:true,
				arrowVsb:true,//true箭头向下，false箭头向上且显示协议
				rules:{
					username:[{required: true, message: '用户名不能为空'}],
					mail:[
						{required: true, message: '邮箱不能为空'},
						{ type: 'email', message: '请输入正确的邮箱地址', trigger: ['blur', 'change'] }
					],
					password:[
						{required: true, message: '密码不能为空'},
						{validator: checkPassword, trigger: 'blur' }
					],
					cfmPassword:[
						{required:true,message:'确认密码不能为空'},
						{validator:checkCfmPassword,trigger:'blur'}
					],
					agreement:[{validator:checkAgreement,trigger:'blur'}]
				},
			};
		},
		methods:{
			register:function(){
				this.$refs['rgstForm'].validate((valid) =>{
					this.rgstForm['password'] =  $.base64.btoa(this.rgstForm['password']);
					if(valid){
						$.ajax({
							url:"register",
							data:this.rgstForm,
							type:"post",
							traditional: true,//传递数组
							success:function(data){
								if(data){
									vue.$refs['rgstForm'].resetFields();
									//todo  提示框动态显示跳转时间
									var count = 10;
									setInterval(vue.$message({
										type: 'success',
										message: '注册成功，请前往邮箱激活账号...'+'正在跳转登录页面中:'+count--,
										}),1000);
									setTimeout("window.location.href='login'",10000);
								}else{
									vue.rgstForm['password'] =  $.base64.atob(vue.rgstForm['password']);
									toastr.error("注册失败！");
								}
							},
							error:function(){
								toastr.error("请求失败");
							},
						});
					}else{
						return;
					}
				});
			},
		},
	});
});
</script>

</html>