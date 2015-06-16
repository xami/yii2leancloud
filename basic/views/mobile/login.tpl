<div class="layout viewport">
    <div class="head">
        <h3 class="step_title">{__('Welcome to Sioeye')}</h3>
        <div class="line"></div>
    </div>

    <div class="content" id="Login-page">
        <div class="input_box">
            <input type="text" name="username" id="username" class="con_inputbox" placeholder="{__('Username/Mobile/Email')}">

            <div class="error_tipdiv" style="display:none">
                <em class="error_ico"></em>
                <div class="error_tips">
                    <div class="et_con">
                        <p></p>
                        <em></em>
                    </div>
                </div>
            </div>

        </div>
        <div class="input_box">
            <input type="password" name="password" id="password" class="con_inputbox" placeholder="{__('Password')}">
            <div class="error_tipdiv" style="display:none">
                <em class="error_ico"></em>
                <div class="error_tips">
                    <div class="et_con">
                        <p></p>
                        <em></em>
                    </div>
                </div>
            </div>
        </div>
        <input type="hidden" id="back_act" name="back_act" value="http://m.hikemobile.com/user.php?act=reg"/>
        <p class="con_p_notes">
            Sioeye Inc.
            <a href="/site/agreement.html" target="_blank">{__('Agreement')}</a>
        </p>
    </div>
    <div class="footer" style="text-align:right;">
        <input id="box-login" class="foo_btn yel_linear" value="{__('Login')}" type="button">
        {if empty($return_url)}
            <a href="/site/register.html" class="turn_link" style="float:none; margin-right:20px;">{__('Register')}</a>
            <a href="/site/reset.html" class="turn_link" style="float:none;">{__('Forgot Password')}</a>
        {else}
            <a href="/site/register.html?return_url={$return_url|urlencode}" class="turn_link" style="float:none; margin-right:20px;">{__('Register')}</a>
            <a href="/site/reset.html?return_url={$return_url|urlencode}" class="turn_link" style="float:none;">{__('Forgot Password')}</a>
        {/if}
    </div>
    <div style="clear: both;">&nbsp;</div>
    {$sso}
    <div id="mask" class="mask hide"></div>
    <div id="maskLoad" class="maskLoad"><span><img src="/css/images/loading_circle.gif" /></span></div>
</div>

<script src="/js/authchoice.js"></script>

{include file="mobile/box.tpl"}