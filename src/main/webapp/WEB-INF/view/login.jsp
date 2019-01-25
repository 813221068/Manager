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
    <div class="login-box text-center animated fadeInDown">
        <div>
        	<div class="font-logo m-b-b">欢迎登录</div>
            <div class="msg">${msg}</div>
            <form id ="loginForm" class="m-t" action="login" method="post">
                <div class="form-group">
                    <input id="username" name="username" type="text" class="form-control user-icon" placeholder="请输入用户名"
                     required="required" onblur="checkUserName()">
                </div>
                <div class="form-group">
                    <input id="psw" type="password" class="form-control psw-icon" placeholder="请输入密码" required="required"
                    onblur="checkPsw()">
                </div>
                 <div>
                    <input id="encodePsw" type="hidden" name="password"/>
                </div>
                <div class="form-group text-left">
                    <div class="checkbox i-checks font-1">
                        <label class="no-padding">
                            <input type="checkbox">
                            <i></i>显示密码
                        </label>
                    </div>
                </div>
                <button class="btn btn-primary block full-width m-b" onclick="return login()">登 录</button>
                <p class="text-muted text-center"> 
                	<a href="javascript:void(0)" onclick="alert('请联系管理员');">忘记密码了？</a> | 
                	<a href="register">注册一个新账号</a>
                </p>

            </form>
        </div>
    </div>
    <div class="copyright text-center m-t">
        <p>© 2019 Border Sign In Form. All rights reserved | Design by
            <a href="http://baidu.com">BlackC</a>
        </p>
    </div>

    <script type="text/javascript">
    $(document).ready(function() {
		$('.i-checks').iCheck({
			checkboxClass : 'icheckbox_square-green',
			radioClass : 'iradio_square-green',
		});
	});
    //showPsw
    $('.i-checks').on('ifChanged', function(event){
    	var x = document.getElementById("psw");
        if (x.type === "password") {
            x.type = "text";
        } else {
            x.type = "password";
        }
   	});
    function login() {
    	var form = document.getElementById("loginForm");
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
		var txt= "输入不合法，用户名由数字和字母组成，长度小于等于16位";
		window.wxc.xcConfirm(txt, window.wxc.xcConfirm.typeEnum.info);
	};
	function checkPsw(){
		var psw = document.getElementById("psw").value;
		var patt = new RegExp("^[A-Za-z0-9]*$");
		if( psw.length<=16 && patt.test(psw)){
			return true;
		}
		var txt= "输入不合法，密码长度不能超过16位";
		window.wxc.xcConfirm(txt, window.wxc.xcConfirm.typeEnum.info);
	};
	function check(){
		var username = document.getElementById("username");
		if(isnull(username.value)){
			var txt= "用户名不能为空";
			window.wxc.xcConfirm(txt, window.wxc.xcConfirm.typeEnum.info);
			return false;
		}
		var password = document.getElementById("psw");
        if(isnull(password.value)){
        	var txt= "密码不能为空";
			window.wxc.xcConfirm(txt, window.wxc.xcConfirm.typeEnum.info);
        	return false;
        }
		return true;
	};
	//判读字符串是否为空
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