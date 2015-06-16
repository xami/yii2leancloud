<script type="text/javascript">
/*<![CDATA[*/
;(function($){
    {literal}
    var isEmail = (function() {
        // ATTENSION: escape is really mess because you have to escape in string and
        // in regular expression.
        var normal = "0-9a-zA-Z\\!#\\$%&'\\*\\+\\-\\/\\=\\?\\^_`\\{\\|\\}~";
        // mix contain normal character and special character
        // special character \ " need to be escaped
        var mix = '\\(\\),:;<>@\\[\\](\\\\\\\\)(\\\\")0-9a-zA-Z\\!#\\$%&\'\\*\\+-\\/\\=\\?\\^_`\\{\\|\\}~\\.\\s';

        // local part
        var mixPattern = '"['+mix+']*"';
        var normalPattern = '[' + normal + '("")]+?';
        var localPattern = ['^((', normalPattern, '\\.)*', normalPattern, ')'].join('');
        // domain part
        var hostnamePattern = '(:?[0-9a-zA-Z\\-]+\\.)*[0-9a-zA-Z\\-]+';
        var ipPattern = '\\[.+?\\]'; // TODO: handle IPv4 and IPv6
        var domainPattern = ['(?:(?:', hostnamePattern, ')|(?:', ipPattern, '))$'].join('');

        var commentPattern = "(?:\\(.*?\\))?";
        var pattern = localPattern + '@' + domainPattern;

        var mixreg = new RegExp(mixPattern, 'g');
        var reg = new RegExp(pattern, 'g');

        return function(email) {
            var valid = true;
            // reset regular expression
            reg.lastIndex = 0;
            // TODO: I want to combine special pattern into normal pattern.
            // Which means just one regular expression can handle everything.
            email = email.replace(mixreg, '""');
            return reg.test(email);
        };
    }());

    var isPhone = (function() {
        var phoneReg = /^(13[0-9]|15[0-9]|18[0-9]|17[0-9])\d{8}$/;

        return function(mobile) {
            return phoneReg.test(mobile);
        };
    }());


    {/literal}

    function generateMixed(n) {
        var chars=['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
        var res = "";
        for(var i = 0; i < n ; i ++) {
            var id = Math.ceil(Math.random()*35);
            res += chars[id];
        }
        return res;
    }

    //存储取得的用户数据
    var User = { };
    var Conf = {
        "debug": false,
        "app_url_login" : []
    };

    var log = function($obj){
        if (window.console && window.console.log && Conf.debug){
            if(typeof $obj == 'string'){
                window.console.log( 'log: ' + $obj );
            }else{
                window.console.log( '' );
                window.console.dir( $obj );
                window.console.log( '' );
            }
        }
    };

    var _return_url = '{$return_url}';
    var maskLoad=$('#maskLoad');

    var verifyCode = function(){
        $("div.error_tipdiv").hide();

        var _code = $("#verifyMobilePhone").val();
        Clean.verifyMobilePhone(_code);
    }

    var re_getCode = function(){
        $("div.error_tipdiv").hide();

        var _mobilePhoneNumber = $("#mobilePhoneNumber").val();
        Clean.requestMobilePhoneVerify(_mobilePhoneNumber);
        delayGet();

    }

    var delayGet = function(){
        var timer = null;
        var el = $('#getCode');
        var second = 60;
        el.unbind('click').addClass('gray_linear');

        $("#verifyCode").bind('click',verifyCode).removeClass('gray_linear');

        //发送验证码后不能再更改下列元素
        $("#username").attr("readonly",true);
        $("#mobilePhoneNumber").attr("readonly",true);
        $("#password").attr("readonly",true);
        $("#verifyPassword").attr("readonly",true);


        $("#code-box").show();

        if(timer){
            clearInterval(timer);
            timer = null;
        }

        timer = setInterval(function(){
            second = second - 1;
            if(second < 0){
                clearInterval(timer);

                el.bind('click',re_getCode).removeClass('gray_linear');
                el.val('{__('Request for phone verification code')}');
                return;
            }

            el.val('{__('Request for phone verification code Once again')}('+second+')');
        },1000);
    };

    var tip;
    var change_tip = function(_id, _status){
        _status = _status ? _status : 'suc';
        var item = $("#"+_id);
        var e = item.next().find('em.error_ico, em.right_ico');
        if(_status=='err'){
            e.removeClass('right_ico').addClass('error_ico');
        }else if(_status=='suc'){
            e.removeClass('error_ico').addClass('right_ico');
        }
    };

    var Clean = {
        init:function(_tip){
            tip = _tip;
        }
        ,register_mobile:function(_user_info){
            if(typeof _user_info.username === 'undefined' || _user_info.username == ''){
                tip('username', '{__('Enter your username')}');
                return;
            }
            if(_user_info.username.length < 4){
                tip('username', '{__('Too short. Username must be at least 4 characters long.')}');
                return;
            }

            var the_username='';
            var _where = { "username":_user_info.username };
            Clean.users(_where);
            the_username = User["username"];
            if(typeof User[the_username] != 'undefined'){
                tip('username', '{__('The Username already exists')}');
                return;
            }


            if(typeof _user_info.mobilePhoneNumber === 'undefined' || _user_info.mobilePhoneNumber == ''){
                tip('mobilePhoneNumber', '{__('Please enter your phone number')}');
                return;
            }
            if(!isPhone(_user_info.mobilePhoneNumber)){
                tip('mobilePhoneNumber', '{__('The mobile phone number you entered is invalid!')}');
                return;
            }

            if(typeof _user_info.password === 'undefined' || _user_info.password == ''){
                tip('password', '{__('Enter your password')}');
                return;
            }
            if(_user_info.password.length < 4){
                tip('password', '{__('Too short. Password must be at least 4 characters long.')}');
                return;
            }
            if(typeof _user_info.verifyPassword === 'undefined' || _user_info.verifyPassword == ''){
                tip('verifyPassword', '{__('Enter your verify password')}');
                return;
            }
            if(_user_info.password != _user_info.verifyPassword){
                tip('verifyPassword', '{__('Passwords do not match.')}');
                return;
            }

            $.ajax({
                data: {
                    "class": 'users',
                    "type": 'post',
                    "data": { "mobilePhoneNumber":_user_info.mobilePhoneNumber, "password":_user_info.password, "username":_user_info.username }
                },

                success: function(json){
                    log(json);
                    if(typeof json.code != 'undefined'){
                        if(json.code=='214'){
                            tip('mobilePhoneNumber', json.error);
                        }else{
                            tip('username', json.error);
                        }

                    }else{
                        delayGet();
                    }
                }
                ,
                'beforeSend':function(){
                    maskLoad.fadeIn('500');
                },
                'complete':function(){
                    maskLoad.fadeOut('500');
                }

            });
        }
        ,verifyMobilePhone:function(_code){
            if(typeof _code === 'undefined' || _code == ''){
                tip('verifyMobilePhone', '{__('Please enter Phone verification code')}');
                return;
            }

            $.ajax({
                data: {
                    "class": 'verifyMobilePhone/'+_code,
                    "type": 'post',
                    "data": {  }
                },
                success: function(json){
                    log(json);
                    if(typeof json.code != 'undefined'){
                        tip('verifyMobilePhone', json.error);
                    }else{
                        alert('{__('Registration is successful, please login')}');
                        if(_return_url != ''){
                            location.href = 'http://'+document.domain+'/mobile/login?return_url='+_return_url;
                        }else{
                            location.href = 'http://'+document.domain+'/mobile/login';
                        }
                    }
                }

            });
        }
        ,requestMobilePhoneVerify:function(_mobilePhoneNumber){
            if(typeof _mobilePhoneNumber === 'undefined' || _mobilePhoneNumber == ''){
                tip('mobilePhoneNumber', '{__('Please enter your phone number')}');
                return;
            }
            if(!isPhone(_mobilePhoneNumber)){
                tip('mobilePhoneNumber', '{__('The mobile phone number you entered is invalid!')}');
                return;
            }

            $.ajax({
                data: {
                    "class": 'requestMobilePhoneVerify',
                    "type": 'post',
                    "data": { "mobilePhoneNumber":_mobilePhoneNumber }
                },
                success: function(json){
                    log(json);
                    if(typeof json.code != 'undefined'){
                        tip('verifyMobilePhone', json.error);
                    }else{
                        {*tip('verifyMobilePhone', '{__('Verification code has been sent to your mobile phone')}');*}
                        alert('{__('Verification code has been sent to your mobile phone')}');
                    }
                }
                ,
                'beforeSend':function(){
                    maskLoad.fadeIn('500');
                },
                'complete':function(){
                    maskLoad.fadeOut('500');
                }
            });
        }
        ,change_password:function(_old_password, _new_password, _re_new_password){
            if(_old_password == ''){
                tip('err', '{__('Please enter the old password')}');
                return;
            }

            if(_new_password == ''){
                tip('err', '{__('Please enter the new password')}');
                return;
            }

            if(_new_password.length < 6){
                tip('err', '{__('Minimum password length is 6')}');
                return;
            }

            if(_re_new_password == ''){
                tip('err', '{__('Enter your verify password')}');
                return;
            }

            if(_re_new_password != _new_password){
                tip('err', '{__('Passwords do not match.')}');
                return;
            }

            $.ajax({
                data: {
                    "class": 'users',
                    "method": 'updatePassword',
                    "type": 'put',
                    "data": { "old_password":_old_password, "new_password":_new_password }
                },
                success: function(json){
                    if(typeof json.code != 'undefined'){
                        if(json.code == '210'){
                            json.error = '{__('The old password mistake')}';
                        }
                        tip('err', json.error);
                    }else{
                        tip('suc', '{__('Change the password successfully')}');
                    }
                }
            });

        }
        ,login: function(_username, _password){
            if(_username == ''){
                tip('username', '{__('Enter your username')}');
                return;
            }
            if(typeof _password == 'undefined' || _password == ''){
                tip('password', '{__('Enter your password')}');
                return;
            }

            var the_username= '';
            var _mobilePhoneNumber = _username;
            var _email = _username;
            if(isPhone(_mobilePhoneNumber)){
                var _where = { "mobilePhoneNumber":_mobilePhoneNumber };
                Clean.users(_where);
                the_username=User["username"];
                if(typeof User[the_username] != 'undefined'){
                    _username = User[the_username]["username"];
                }
            }else if(isEmail(_email)){
                var _where = { "email":_email };
                Clean.users(_where);
                the_username=User["username"];
                if(typeof User[the_username] != 'undefined'){
                    _username = User[the_username]["username"];
                }
            }


//            var _rememberMe = $('#rememberMe').attr('checked') == undefined ? 0 : 1;
            var _rememberMe = 1;
            var _data = { "username":_username , "password":_password, "rememberMe":_rememberMe };

            $.ajax({
                data: {
                    "class": 'login',
                    "type": 'get',
                    "data": _data
                },
                success: function(json){
                    log(json);

                    if(typeof json.code != 'undefined' && json.code != '200'){
                        if(json.code == '216'){
                            var _where = { "username":_username };
                            Clean.users(_where);
                            the_username=User["username"];
                            if(typeof User[the_username] != 'undefined'){
                                Clean.requestEmailVerify(User[the_username]["email"]);
                            }
                        }
                        tip('username', json.error);
                    }else{
                        Clean.sso_login(Conf.app_url_login);
                        $('div.beacon-user').html(
                                '<a href="/center">'+ json.username+'</a> / <a href="/user/logout">{__('Logout')}</a>'
                        );
                    }
                }
                ,
                'beforeSend':function(){
                    maskLoad.fadeIn('500');
                },
                'complete':function(){
                    maskLoad.fadeOut('500');
                }
            });
        }
        ,register:function(_user_info){
            if(typeof _user_info.username === 'undefined' || _user_info.username == ''){
                tip('err', '{__('Enter your username')}');
                return;
            }
            if(_user_info.username.length < 4){
                tip('err', '{__('Too short. Username must be at least 4 characters long.')}');
                return;
            }

            if(typeof _user_info.password === 'undefined' || _user_info.password == ''){
                tip('err', '{__('Enter your password')}');
                return;
            }
            if(_user_info.password.length < 4){
                tip('err', '{__('Too short. Password must be at least 4 characters long.')}');
                return;
            }
            if(typeof _user_info.verifyPassword === 'undefined' || _user_info.verifyPassword == ''){
                tip('err', '{__('Enter your verify password')}');
                return;
            }
            if(_user_info.password != _user_info.verifyPassword){
                tip('err', '{__('Passwords do not match.')}');
                return;
            }

            if(typeof _user_info.email === 'undefined' || _user_info.email == ''){
                tip('err', '{__('Enter your E-mail')}');
                return;
            }
            if(!isEmail(_user_info.email)){
                tip('err', '{__('The email address you entered is invalid!')}');
                return;
            }

            $.ajax({
                data: {
                    "class": 'users',
                    "type": 'post',
                    "data": { "email":_user_info.email, "password":_user_info.password, "username":_user_info.username }
                },
                success: function(json){
                    log(json);
                    if(typeof json.code != 'undefined'){
                        tip('err', json.error);
                    }else{
                        tip('suc', '{__('Thank you for your registration. Please check your email.')}');
                    }

                }
            });
        }
        ,resetPasswordBySmsCode:function(_mobilePhoneNumber, _verifyMobilePhone, _password, _verifyPassword){
            if(_verifyMobilePhone == ''){
                tip('verifyMobilePhone', '{__('Please enter Phone verification code')}');
            }

            if(typeof _password === 'undefined' || _password == ''){
                tip('password', '{__('Enter your password')}');
                return;
            }
            if(_password.length < 4){
                tip('password', '{__('Too short. Password must be at least 4 characters long.')}');
                return;
            }
            if(typeof _verifyPassword === 'undefined' || _verifyPassword == ''){
                tip('verifyPassword', '{__('Enter your verify password')}');
                return;
            }
            if(_password != _verifyPassword){
                tip('verifyPassword', '{__('Passwords do not match.')}');
                return;
            }

            $.ajax({
                data: {
                    "class": 'resetPasswordBySmsCode/'+_verifyMobilePhone,
                    "type": 'put',
                    "data": { "password": _password }
                },
                success: function(json){
                    log(json);
                    if(typeof json.code != 'undefined'){
                        tip('verifyMobilePhone', json.error);
                    }else{
                        alert('{__('Change the password successfully, Please Login use the new password')}');

                        if(_return_url != ''){
                            location.href = 'http://'+document.domain+'/mobile/login?return_url='+_return_url;
                        }else{
                            location.href = 'http://'+document.domain+'/mobile/login';
                        }
                    }
                }

            });
        }
        ,requestPasswordReset:function(_username){
            if(typeof _username == 'undefined' || _username == ''){
                tip('username', '{__('Enter your username or Email')}');
                $("#reset").removeClass('gray_linear');
                return;
            }

            var _email = _username;
            var _mobilePhoneNumber = _username;
            var the_username  = '';

            //获取用户资料
            if(isEmail(_email)){
                var _where = { "email":_email };
                Clean.users(_where);
                the_username = User["username"];
                if(typeof User[the_username] != 'undefined'){
                    _username = User[the_username]["username"];
                    _mobilePhoneNumber = User[the_username]["mobilePhoneNumber"];
                }
            }else if(isPhone(_username)){
                var _where = { "mobilePhoneNumber":_mobilePhoneNumber };
                Clean.users(_where);
                the_username = User["username"];
                if(typeof User[the_username] != 'undefined'){
                    _username = User[the_username]["username"];
                    _email = User[the_username]["email"];
                }
            }else{
                var _where = { "username":_username };
                Clean.users(_where);
                the_username = User["username"];
                if(typeof User[_username] != 'undefined'){
                    _email = User[the_username]["email"];
                    _mobilePhoneNumber = User[the_username]["mobilePhoneNumber"];
                }
            }


            if(typeof _email != 'undefined' && isEmail(_email)){
                $.ajax({
                    data: {
                        "class": 'requestPasswordReset',
                        "type": 'post',
                        "data": { "email":_email }
                    },
                    success: function(json){
                        log(json);

                        if(typeof json.code != 'undefined'){
                            change_tip('username','err');
                            tip('username', json.error);
                        }else{
                            change_tip('username','suc');
                            tip('username', '{__('The system has been sent a email to you.')}');
                        }

                        $("#reset").removeClass('gray_linear');
                    }
                });
            }else if(typeof _mobilePhoneNumber != 'undefined' && isPhone(_mobilePhoneNumber)){
                $.ajax({
                    data: {
                        "class": 'requestPasswordResetBySmsCode',
                        "type": 'post',
                        "data": { "mobilePhoneNumber":_mobilePhoneNumber }
                    },
                    success: function(json){
                        log(json);
                        if(typeof json.code != 'undefined'){
                            tip('username', json.error);
                        }else{
//                            change_tip('username','suc');
                            {*tip('username', '{__('The system has been sent a new password to you phone')}');*}
                            alert('{__('The system has been sent a new password to you phone')}');

                            $("#reset").val('{__('Change Password')}');

                            //显示验证码输入框
                            $("#code-box, #mobile-box, #pass-box, #repass-box").show();
                            //设置手机号码，并且置为只读
                            $("#mobilePhoneNumber").val(_mobilePhoneNumber).attr("readonly",true);
                            $("#username").val(the_username).attr("readonly",true);


                            $("#reset").unbind('click');
                            $("#reset").bind('click',function(){

                                $("div.error_tipdiv").hide();
                                change_tip('username','err');

                                var _mobilePhoneNumber = $("#mobilePhoneNumber").val();
                                var _verifyMobilePhone = $("#verifyMobilePhone").val();
                                var _password = $("#password").val();
                                var _verifyPassword = $("#verifyPassword").val();

                                Clean.resetPasswordBySmsCode(_mobilePhoneNumber, _verifyMobilePhone, _password, _verifyPassword);

                            });

                        }

                        $("#reset").removeClass('gray_linear');
                    }
                });
            }else{
                tip('username', '{__('You enter the account does not exist')}');
                $("#reset").removeClass('gray_linear');
            }
        }
        ,update_cart:function(){
            if(typeof $('.beacon-cart') != 'undefined'){
                $.ajax({
                    type: "POST",
                    url: "/cart/count",
                    success: function (r) {
                        $('.beacon-cart').find('.cart-count').find('.count').html(r);
                    }
                });
            }

        }
        ,requestEmailVerify:function(_email){
            if(_email == ''){
                tip('err', '{__('Enter your E-mail')}');
                return;
            }

            $.ajax({
                data: {
                    "class": 'requestEmailVerify',
                    "type": 'post',
                    "data": { "email":_email }
                },
                success: function(json){
                    log(json);
                    tip('suc', '{__('Please activate the account first，The system has been sent a email to you.')}');
                }
            });
        }
        ,users:function(_where){
            $.ajax({
                data: {
                    "class": 'users',
                    "type": 'get',
                    "where": _where
                },
                success: function(json){
                    log(json);
                    if(typeof json.results[0] != 'undefined'){
                        var user_info = json.results[0];
                        var username = json.results[0]["username"];
                        User["username"] = username;
                        User[username] = user_info;
                    }else{
                        {*tip('username', '{__('Incorrect username or password / Your account is unactivated')}');*}
                    }
                }
            });
        }
        ,sso_login:function(app_url_login){
            var token = '';
            $.ajax({
                type: "POST",
                url: "/api/getToken",
                dataType: "html",
                success: function (html) {
                    log(html);
                    if(html != ''){
                        token = html;
                    }
                }
            });

            var load_time=0;
            for(var i=0;i<app_url_login.length;i++){
                var _script = '';
                var src = app_url_login[i];
                var s = src.indexOf('?');
                if(s>0){
                    _script = '<script class="loginScript" src="'+src+'&token='+encodeURIComponent(token)+'&_='+generateMixed(10)+'"><\/script>';
                    _link = src+'&token='+encodeURIComponent(token)+'&_='+generateMixed(10);
                }else{
                    _script = '<script class="loginScript" src="'+src+'?token='+encodeURIComponent(token)+'&_='+generateMixed(10)+'"><\/script>';
                    _link = src+'?token='+encodeURIComponent(token)+'&_='+generateMixed(10);
                }

                $.getScript(_link,function(){
                    load_time ++;
                });
            }


            var timer = setInterval(function(){
                log(load_time);
                if(load_time == i){
                    clearInterval(timer);
                    timer = null;

                    {*tip('suc', '{__('Login success')}');*}
                    if(_return_url != ''){
                        location.href = _return_url;
                    }else{
                        location.href = 'http://'+document.domain+'/';
                    }

                    if(self != top){
                        parent.location.reload();
                    }else{
                        //关闭登录窗口，更新购物车
                        $("#Login-page").hide();
//                        Clean.update_cart();
                    }
                }
            },100);

            setTimeout(function(){
                if(timer){
                    tip('err', '{__('Login Error')}');
                }
                clearInterval(timer);
                timer = null;
            },10000);
        }
    };

    window.Clean = Clean;

})(jQuery);
/*]]>*/
</script>