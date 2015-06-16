{include file="mobile/clean.tpl"}
<script type="text/javascript">
/*<![CDATA[*/
    (function($){
        document.box=null;

        var tip = function(_id, content){
            content = content ? content : '';
            var item = $("#"+_id);
            item.next().find('.et_con p').html(content);
            item.next().show();
        };

        var Clean = window.Clean;
        Clean.init(tip);

        document.domain = '{$app->request->getServerName()}';

        $('.hoauthWidget a').click(function() {
            var signinWin;
            var screenX     = window.screenX !== undefined ? window.screenX : window.screenLeft,
                    screenY     = window.screenY !== undefined ? window.screenY : window.screenTop,
                    outerWidth  = window.outerWidth !== undefined ? window.outerWidth : document.body.clientWidth,
                    outerHeight = window.outerHeight !== undefined ? window.outerHeight : (document.body.clientHeight - 22),
                    width       = 480,
                    height      = 680,
                    left        = parseInt(screenX + ((outerWidth - width) / 2), 10),
                    top         = parseInt(screenY + ((outerHeight - height) / 2.5), 10),
                    options    = (
                    'width=' + width +
                    ',height=' + height +
                    ',left=' + left +
                    ',top=' + top
                    );

            signinWin=window.open(this.href,'Login',options);

            if (window.focus) { signinWin.focus() }

            return false;
        });

        function setParentHeight($box_top){
            var $pIframe = $('#login_one_frame',parent.document),
                    height = $box_top.attr('data-height');

            $pIframe.attr('height',height);
        }

        $("#for-login,#go-log,#to-go-log").click(function(){
            $("#Login-page").show();
            $("#Register-page").hide();
            $("#Restore-page").hide();
            document.box = $("#Login-page");

            setParentHeight(document.box);
        });

        $("#for-reg,#go-reg").click(function(){
            $("#Login-page").hide();
            $("#Register-page").show();
            $("#Restore-page").hide();
            document.box = $("#Register-page");

            setParentHeight(document.box);
        });

        $("#go-res").click(function(){
            $("#Login-page").hide();
            $("#Register-page").hide();
            $("#Restore-page").show();
            document.box = $("#Restore-page");

            setParentHeight(document.box);
        });


        $("div.alert-box a.closed").click(function(){
            $("#Login-page").hide();
            $("#Register-page").hide();
            $("#Restore-page").hide();
            document.box = null;


            var $box_top = $(this).parents('.lr-cover'),
                    $pCover = $('#login_layer_bg',parent.document),
                    $pBox = $('#login_layer',parent.document);
            $box_top.hide();
            $pBox.hide();
        });

        var api = '/api/rest.html';
        $.ajaxSetup({
            url: api,
            type: "get",
            async: false,
            dataType: "json",
            error: function(json){

            }

        });


        $("#box-login").click(function(){
            document.box = $("#Login-page");
            var _username = document.box.find("#username").val();
            var _password = document.box.find("#password").val();
            Clean.login(_username, _password);
        });

        $("#box-res").click(function(){
            document.box = $("#Restore-page");

            var _username = document.box.find("#UserRecoveryForm_login_or_email").val();
            Clean.requestPasswordReset(_username);
        });

        $("#box-reg").click(function(){
            document.box = $("#Register-page");

            var _user_info = { };
            _user_info.username = document.box.find("#RegistrationForm_username").val();
            _user_info.password = document.box.find("#RegistrationForm_password").val();
            _user_info.verifyPassword = document.box.find("#RegistrationForm_verifyPassword").val();
            _user_info.email = document.box.find("#RegistrationForm_email").val();
            Clean.register(_user_info);
        });


        var sendCode = function(){
            document.box = $("#Register-page");

            $("div.error_tipdiv").hide();

            var _user_info = { };
            _user_info.username = document.box.find("#username").val();
            _user_info.password = document.box.find("#password").val();
            _user_info.verifyPassword = document.box.find("#verifyPassword").val();
            _user_info.mobilePhoneNumber = document.box.find("#mobilePhoneNumber").val();
            Clean.register_mobile(_user_info);

        };



        //这一步如果请求返回正确，则已经注册
        $("#getCode").click(sendCode);
        $("#verifyCode").addClass('gray_linear');

        $("#reset").click(function(){
            $(this).addClass('gray_linear');
            $("div.error_tipdiv").hide();

            var _username = $("#username").val();
            Clean.requestPasswordReset(_username);
        })


    })(jQuery);
/*]]>*/
</script>