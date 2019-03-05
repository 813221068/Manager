//自定义js
//判读对象是否为空
function isnull(str){
	if(str == undefined || str==null){
		return true;
	}
	str = str.toString().replace(/\s+/g,"");
	if(str==''){
		return true;
	}else{
		return false;
	}
};
/**
 * 清空参数
 * @param datas
 * @returns
 */
function cleanParams(datas){
	var v_data ={};
	for(var a in datas){
		if (datas[a] != null && datas[a] instanceof Array) {
			v_data[a]=[];
		}else {
			v_data[a] = null;
		}
	}
	return v_data;
};
// 公共配置
//消息提示框设置
toastr.options = {  
        closeButton: false,                                            // 是否显示关闭按钮，（提示框右上角关闭按钮）
        debug: false,                                                    // 是否使用deBug模式
        progressBar: true,                                            // 是否显示进度条，（设置关闭的超时时间进度条）
        positionClass: "toast-top-center",              // 设置提示款显示的位置
        onclick: null,                                                     // 点击消息框自定义事件 
        showDuration: "300",                                      // 显示动画的时间
        hideDuration: "500",                                     //  消失的动画时间
        timeOut: "1000",                                             //  自动关闭超时时间 
        extendedTimeOut: "1000",                             //  加长展示时间
        showEasing: "swing",                                     //  显示时的动画缓冲方式
        hideEasing: "linear",                                       //   消失时的动画缓冲方式
        showMethod: "fadeIn",                                   //   显示时的动画方式
        hideMethod: "fadeOut"                                   //   消失时的动画方式
    }; 

$(document).ready(function () {

    // MetsiMenu
    $('#side-menu').metisMenu();

    //固定菜单栏
/*    $(function () {
        $('.sidebar-collapse').slimScroll({
            height: '100%',
            railOpacity: 0.9,
            alwaysVisible: false
        });
    });*/


/*    // 菜单切换
    $('.navbar-minimalize').click(function () {
        $("body").toggleClass("mini-navbar");
        SmoothlyMenu();
    });*/



});


