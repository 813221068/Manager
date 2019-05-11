<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>业务申报审批系统 - 登录</title>
    <%@ include file="common.jsp" %>
</head>
<body class="gray-bg login-bg">
    <div id="content" class="login-box text-center animated fadeInDown"  >
    	<!--  -->
        <div>
			<el-tabs type="border-card" :stretch=true v-if="!forgetFormVsb">
				<el-tab-pane label="账号登录">
					<el-form  status-icon label-postion="left" :rules="rules" :model="loginForm" ref="loginForm" 
					v-if="!forgetFormVsb">
<!-- 						<el-form-item>
							<div class="font-logo">欢迎登录</div>
						</el-form-item> -->
						<el-form-item  prop="username" class="m-t">
							<el-input placeholder="请输入用户名" v-model="loginForm.username" prefix-icon="fa fa-user"  clearable >
						</el-form-item>
						<el-form-item  prop="password" >
							<el-input type="password" placeholder="请输入密码" v-model="loginForm.password" prefix-icon="fa fa-lock" clearable show-password>
							</el-form-item>
							<el-form-item>
								<el-button type="primary" class=" full-width" @click="login()">登录</el-button>
							</el-form-item>
							<el-form-item>
								<p class="text-muted text-center"> 
									<el-button type="text" @click="forgetFormVsb=true;" >忘了密码？ </el-button>| 
									<el-button type="text" onclick="javascrtpt:window.location.href = 'register'"> 注册一个新账号</el-button>
								</p>
						</el-form-item>
					</el-form>
				</el-tab-pane>
				<el-tab-pane label="邮箱登录">
					<el-form  status-icon label-postion="left" :rules="rules" :model="mailForm" ref="mailForm" >
<!-- 						<el-form-item>
							<div class="font-logo">欢迎登录</div>
						</el-form-item> -->
						<el-form-item  prop="mail" class="m-t">
							<el-input placeholder="请输入邮箱" v-model="mailForm.mail" prefix-icon="fa fa-envelope"  clearable >
						</el-form-item>
						<el-form-item  prop="verifyCode" >
							<el-col :span="12">
								<el-input placeholder="输入验证码" v-model="mailForm.verifyCode" prefix-icon="fa fa-lock" clearable >
							</el-col>
							<el-button type="text" id="sendCodeBtn" @click="sendVerifyCode()" :disabled="sendCodeBtnDisabled"
							>发送验证码</el-button>
						</el-form-item>
							<el-form-item>
								<el-button type="primary" class=" full-width" @click="mailLogin()">登录</el-button>
							</el-form-item>
							<el-form-item>
								<p class="text-muted text-center"> 
									<el-button type="text" @click="forgetFormVsb=true;" >忘了密码？ </el-button>| 
									<el-button type="text" onclick="javascrtpt:window.location.href = 'register'"> 注册一个新账号</el-button>
								</p>
						</el-form-item>
					</el-form>
				</el-tab-pane>
			</el-tabs>
            
        </div>
        <div style=" padding: 50px;" v-if="forgetFormVsb">
            <el-form :rules="rules" :model="forgetForm" ref="forgetForm">
                <el-form-item>
                    <div class="font-logo">重置密码</div>
                </el-form-item>
                <el-form-item label="邮箱:" prop="mail">
                    <el-input placeholder="请输入邮箱地址" v-model="forgetForm.mail"  clearable prefix-icon="fa fa-envelope">
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" class=" full-width" @click="forgetPsw()">确认</el-button>
                </el-form-item>
                <el-form-item>
                    <el-button type="text" @click="forgetFormVsb=false;" >返回登录 </el-button> 
                </el-form-item>
            </el-form>
        </div>
    </div>
    <div class="copyright text-center m-t">
        <p>© 2019 Border Sign In Form. All rights reserved | Design by
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
            return {
            	resendSeconds:60,//重新发送验证码时间 单位：s秒
            	sendCodeBtnDisabled:false,//发送验证码按钮是否禁用
                forgetFormVsb:false,
                loginForm:{
                    username:null,
                    password:null,
                },
                mailForm:{
                	mail:null,
                	verifyCode:null,
                },
                forgetForm:{
                    mail:null,
                },
                rules:{
                    username:[
                        {required: true, message: '用户名不能为空'},
                    ],
                    password:[
                        {required: true, message: '密码不能为空'},
                        {validator: checkPassword, trigger: 'blur' }
                    ],
                    mail:[
                        {required: true, message: '邮箱不能为空'},
                        { type: 'email', message: '请输入正确的邮箱地址', trigger: ['blur', 'change'] }
                    ],
                },
            };
        },
        mounted:function(){
        	//防止el表达式取值为空  == 空白 报错
        	if(!${logout eq null}){
        		this.$message({
                    message:"登出成功",
                    type:"success",
                })
        	}

        },
        methods:{
        	mailLogin:function(){
        		this.$refs['mailForm'].validate((valid) =>{
        			if(valid){
        				if(isnull(this.mailForm.verifyCode)){
        					callback(new Error('验证码不能为空'))
        				}
        				$.ajax({
                            url:"login",
                            data:vue.mailForm,
                            type:"post",
                            success:function(data){
                                if(data==2){
                                    window.location.href='index';
                                }else if(data==0){
                                    vue.$message({
                                        message:'验证码不正确',
                                        type:'error'
                                    });
                                }else if(data==1){
                                    vue.$message({
                                        message:'此账号未激活',
                                        type:'error'
                                    });
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
        	sendVerifyCode:function(){
        		this.$refs['mailForm'].validate((valid) =>{
        			if(valid){
        				$.ajax({
	        				url:'sendVerifyCode',
	        				data:{'mail':vue.mailForm.mail},
	        				type:'post',
	        				success:function(data){
	        					if(data==0){
	        						vue.$message({
	        							message:"此邮箱未注册",
	        							type:"warning"
	        						});
	        					}else if(data==1){
	        						vue.$message({
	        							message:"此账号未激活",
	        							type:"warning"
	        						});
	        					}else if(data==2){
	        						vue.$message({
	        							message:"发送验证码失败",
	        							type:"warning"
	        						});
	        					}else if(data==3){
	        						vue.$message({
	        							message:"验证码发送成功，请前往邮箱查看",
	        							type:"success"
	        						});
	        						var btn = document.getElementById('sendCodeBtn');
			        				var span = btn.children[0];
			        				vue.sendCodeBtnDisabled = true;
			        				var clock = setInterval(
			        					function(){
			        						vue.resendSeconds -= 1;
				        					if(vue.resendSeconds>0){
				        						span.innerText = vue.resendSeconds+"秒重新发送";
				        					}
				        					else{
				        						span.innerText = "发送验证码";
				        						vue.sendCodeBtnDisabled = false;
				        						vue.resendSeconds = 60;
				        						clearInterval(clock);
				        					}
			        					}
			        				,1000);
	        					}
	        				},
	        				error:function(){
	        					 toastr.error("请求失败");
	        				}
	        			});	        			        				
        	
        			}
        			else{
        				return;
        			}
        			
        		});
        	},
            login:function(){
                this.$refs['loginForm'].validate((valid) =>{
                    password = this.loginForm.password;
                    var para = {"username":this.loginForm.username,"password":$.base64.btoa(password)};
                    if(valid){
                        $.ajax({
                            url:"login",
                            data:para,
                            type:"post",
                            traditional: true,//传递数组
                            success:function(data){
                                if(data==2){
                                    window.location.href='index';
                                }else if(data==0){
                                    vue.$message({
                                        message:'用户名或密码不正确',
                                        type:'error'
                                    });
                                    // toastr.error("登录失败！");
                                }else if(data==1){
                                    vue.$message({
                                        message:'此账号未激活',
                                        type:'error'
                                    });
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
            forgetPsw:function(){
                this.$refs['forgetForm'].validate((valid)=>{
                    if(valid){
                        $.ajax({
                            url:'nologin/forgetPsw',
                            data:this.forgetForm,
                            type:'post',
                            success:function(data){
                            	// console.log(data);
                                if(data){
                                    vue.$message({
                                        message:'请前往邮箱重置密码',
                                        type:'success',
                                    })
                                }else{
                                    toastr.error("此邮箱没有注册或未激活");
                                }
                            }
                        })
                    }
                });
            },
        },
    });
});
</script>
</html>