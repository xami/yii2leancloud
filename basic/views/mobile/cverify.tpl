<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Sioeye</title>
    <link href="https://dn-avoscloud.qbox.me/statics/bootstrap.min.css" rel="stylesheet">

    <style>
        h3 {
            text-align: center;
            margin-top: 50px;
            font-weight: normal;
        }
    </style>
</head>
<body>

<div class=" container">
    <h3 id="tip" style="display:none"></h3>
    <!-- <h3 id="tip">Test</h3> -->



</div><!--end container-->
<script src="https://dn-avoscloud.qbox.me/statics/jquery.min.js"></script>
<script src="https://dn-avoscloud.qbox.me/statics/jquery.jsonp.js"></script>

<script type="text/javascript">
    var url = "https://api.leancloud.cn/1.1/verifyEmail/";//如果页面运行在自己的服务器，需要写定一个绝对 URL,类似 "https://api.leancloud.cn/1.1/verifyEmail/"
    var tip_err ="{__('Email validation error')}"; //邮箱验证出错提示
    var tip_success ="{__('Your Sioeye account has been activated. You can go back to Sioeye to login now.')}";//邮箱验证成功提示
    function getParam() {
        var prmstr = window.location.search.substr(1);
        var prmarr = prmstr.split("&");
        var params = { };

        for (var i = 0; i < prmarr.length; i++) {
            var tmparr = prmarr[i].split("=");
            params[tmparr[0]] = tmparr[1];
        }
        return params;
    }

    //获得token,以验证邮件合法性
    var token = location.search.match(/token=(\w*)/);
    if(token&&token[1]){
        token = token[1];
    }
    function verify(){
        if(!token){
            return;
        }
        $.jsonp({
            url:url+token,
            callbackParameter: "callback",
            cache: false,
            success:function(result){
                $("#tip").show();
                if(result.error){
                    if(result.error == 'Token 已经过期。'){
                        result.error = '{__('Token has expired.')}';
                    }
                    $("#tip").text(result.error);
                }else{
                    $("#tip").html(tip_success);
                }
            },
            error:function(result,text){
                $("#tip").text("{__('Server error')}");
            }
        });
    }

    $(function(){
        verify();
    })

</script>

</body>
</html>