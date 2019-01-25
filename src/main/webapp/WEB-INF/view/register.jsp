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

    <div class="register-box text-center animated fadeInDown">
        <div>
            <h3>欢迎注册 </h3>
            <p>创建一个新账户</p>
            <div class="msg">${msg}</div>
            <form id="registerForm" class="m-t" role="form" action="register" method="post">
                <div class="form-group">
                    <input id="username" name="username" type="text" class="form-control" placeholder="请输入用户名" 
                    onblur="checkUserName()" required="required">
                </div>
                <div class="form-group">
                    <input id="psw"  type="password" class="form-control" placeholder="请输入密码" onblur="checkPsw()" 
                    required="required">
                </div>
                <div class="form-group">
                    <input id="confirmPsw"type="password" class="form-control" placeholder="请再次输入密码" onblur="checkConfirmPsw()"
                    required="required">
                </div>
                <div>
                    <input id="encodePsw" type="hidden" name="password"/>
                </div>
				<div class="form-group text-left">
                    <div class="i-checks">
                        <label class="no-padding">
                            <input type="checkbox" id="checkAgree"  checked><i></i> 我已阅读并同意注册协议</label>
							<i class="fa fa-angle-down" aria-hidden="true" id="downArrow"></i>
							<i class="fa fa-angle-up display" aria-hidden="true" id="upArrow"></i>
                    </div>
                    <div class="display" id="protocol">
                    	<a href="http://baidu.com" target="_blank">《注册协议》</a>
                    </div>
                </div>
                <button class="btn btn-primary block full-width m-b" onclick="return registerForm()">注 册</button>

                <p class="text-muted text-center"><small>已经有账户了？</small><a href="login">点此登录</a>
                </p>

            </form>
        </div>
    </div>
    
    <div class="copyright text-center m-t">
        <p>© 2019 Border Register In Form. All rights reserved | Design by
            <a href="http://baidu.com">BlackC</a>
        </p>
    </div>

	<script>
		$(document).ready(function() {
			$('.i-checks').iCheck({
				checkboxClass : 'icheckbox_square-green',
				radioClass : 'iradio_square-green',
			});
			//显示注册协议
			$("#downArrow").click(function(){
				document.getElementById("downArrow").style.display = "none";
				document.getElementById("upArrow").style.display = "inline";
				document.getElementById("protocol").style.display = "inline";
				
			});
			$("#upArrow").click(function(){
				document.getElementById("downArrow").style.display = "inline";
				document.getElementById("upArrow").style.display = "none";
				document.getElementById("protocol").style.display = "none";
			});
		}); 
	    function registerForm() {
			var form = document.getElementById("registerForm");
			if(check()){
				var psw = document.getElementById("psw");
				var encodePsw = document.getElementById("encodePsw");
				//加密
				encodePsw.value = $.base64.btoa(psw.value);
				form.submit();
			}
			
			return false;
		};
		function checkUserName() {
			var username = document.getElementById("username").value;
			var patt = new RegExp("^[A-Za-z0-9]*$");
			if( username.length<=16 && patt.test(username)){
				return true;
			}
	//		alert("输入不合法，用户名由数字和字母组成，长度小于等于16位");
			var txt= "输入不合法，用户名由数字和字母组成，长度小于等于16位";
			window.wxc.xcConfirm(txt, window.wxc.xcConfirm.typeEnum.info);
		};
		function checkPsw(){
			var psw = document.getElementById("psw").value;
			var patt = new RegExp("^[A-Za-z0-9]*$");
			if( psw.length<=16 && psw.length<6 && patt.test(psw)){
				return true;
			}
			var txt= "输入不合法，密码为6-16位字母和数字组合";
			window.wxc.xcConfirm(txt, window.wxc.xcConfirm.typeEnum.info);
		};
		function checkConfirmPsw(){
			var confirmPsw = document.getElementById("confirmPsw").value;
			var psw = document.getElementById("psw").value;
			var patt = new RegExp("^[A-Za-z0-9]*$");
			if(confirmPsw != psw){
				var txt= "两次输入密码不一致,请重新输入";
				window.wxc.xcConfirm(txt, window.wxc.xcConfirm.typeEnum.info);
			}
		}
		function check() {
			//输入不为空 ，两次密码相同 ，点击同意
			var username = document.getElementById("username");
			if(isnull(username.value)){
				var txt= "用户名不能为空";
				window.wxc.xcConfirm(txt, window.wxc.xcConfirm.typeEnum.info);
				return false;
			}
			var password = document.getElementById("psw");
            if(isnull(password.value)){
            //	alert("密码不能为空");
            	var txt= "密码不能为空";
				window.wxc.xcConfirm(txt, window.wxc.xcConfirm.typeEnum.info);
            	return false;
            }
            var confirmPsw = document.getElementById("confirmPsw");
            if(isnull(confirmPsw.value)){
            //	alert("确认密码不能为空");
            	var txt= "确认密码不能为空";
				window.wxc.xcConfirm(txt, window.wxc.xcConfirm.typeEnum.info);
            	return false;
            }
            if(password.value != confirmPsw.value){
            //	alert("两次输入密码不一致");
            	var txt= "两次输入密码不一致";
                window.wxc.xcConfirm(txt, window.wxc.xcConfirm.typeEnum.info);
            	return false;
            } 
            if(!document.getElementById("checkAgree").checked){
            //	alert("请先同意注册协议");
            	var txt= "请先同意注册协议";
				window.wxc.xcConfirm(txt, window.wxc.xcConfirm.typeEnum.info);
            	return false;
            }
            return true;
		};
		//判读是否为空
		function isnull(str){
			str = str.replace(/\s+/g,"");
			if(str==''||str==undefined||str==null){
				return true;
			}else{
				return false;
			}
		};
	</script>

</body>

</html>