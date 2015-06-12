<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Sioeye</title>
    <link href="https://dn-avoscloud.qbox.me/statics/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container">

    <h3>{__('Reset Password')}</h3>
    <hr>

    <form class="form-horizontal form login-form" name="resetform" >
        <!-- <legend>{__('Reset Password')}</legend> -->

        <div class="alert" style="display:none" id="error">
            <button type="button" class="close" data-dismiss="alert">&times;</button>
        </div>

        <div class="form-group">
            <label class="col-sm-2 control-label" for="inputEmail" >{__('New Password')}</label>
            <div class="col-sm-4">
                <input type="password" id="inputEmail" class="form-control" placeholder="{__('New Password')}" name="password" required>
            </div>
        </div>

        <div class="form-group">
            <label class="col-sm-2 control-label" for="inputPassword" >{__('Confirm Password')}</label>
            <div class="col-sm-4">
                <input type="password" id="inputPassword" class="form-control" placeholder="{__('Confirm Password')}"  name="password1" required>
            </div>
        </div>

        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-4">
                <button type="button" class="btn btn-default" id="reset">{__('Reset')}</button>
            </div>
        </div>

    </form>




</div><!--end container-->
<script src="https://dn-avoscloud.qbox.me/statics/jquery.min.js"></script>
<script src="https://dn-avoscloud.qbox.me/statics/jquery.jsonp.js"></script>


<script type="text/javascript">
{literal}
//获得token
var token = location.search.match(/token=(\w*)/);
if(token&&token[1]){
    token = token[1];
}
{/literal}
$(function(){
    $("#reset").click(function(){
        var p = $("[name=password]");
        var p1 = $("[name=password1]");
        if(p.val()!=p1.val()){
            $("#error").show();
            $("#error").text("{__('Passwords do not match.')}");//密码输入不一致提示
        }
        if(p.val()&&p1.val()&&p.val()==p1.val()){
            $.jsonp({
                url:"https://api.leancloud.cn/1.1/resetPassword/"+token,//如果页面运行在自己的服务器，需要写定一个绝对 URL,类似 "https://api.leancloud.cn/1.1/resetPassword/"
                data:{ "password":p.val() },
                callbackParameter: "callback",
                cache: false,
                success:function(result){
                    $("#error").show();//成功和失败都会有提示信息, 共用 #error
                    if(result.error){
                        if(result.error == 'Token 已经过期。'){
                            result.error = '{__('Token has expired.')}';
                        }
                        $("#error").text(result.error);
                    }else{
                        $("#error").html("{__('Password reset is successful, please login')}, waiting <span class=\"sec\">5</span>s.");

                        //5秒后跳转
                        var time = 5;
                        var timer = setInterval(function(){
                            if(time<1){
                                clearInterval(timer);
                                timer = null;

                                window.location.href = 'http://{$SIO_WEB_DOMAIN}';
                            }else{
                                time--;
                                $("span.sec").text(time);
                            }
                        },1000);
                    }
                },
                error:function(result,text){
                    $("#error").text("{__('Server error')}");
                }
            });
        }

    });
});
</script>

</body>
</html>