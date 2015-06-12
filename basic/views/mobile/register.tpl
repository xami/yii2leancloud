<div class="layout viewport">
    <div class="head">
        <h3 class="step_title">{__('Welcome to Sioeye')}</h3>
        <div class="line"></div>
    </div>

    <div class="content" id="Register-page">
        <div class="input_box">
            <input type="text" name="username" id="username" class="con_inputbox" placeholder="{__('Please enter your username')}">
            <div class="error_tipdiv" style="display:none">
                <em class="error_ico"></em>
                <div class="error_tips">
                    <div class="et_con">
                        <p data-default="{__('Please enter your username')}"></p>
                        <em></em>
                    </div>
                </div>
            </div>
        </div>

        <div class="input_box">
            <input type="text" name="mobilePhoneNumber" id="mobilePhoneNumber" class="con_inputbox" placeholder="{__('Please enter your phone number')}">
            <div class="error_tipdiv" style="display:none">
                <em class="error_ico"></em>
                <div class="error_tips">
                    <div class="et_con">
                        <p data-default="{__('Please enter your phone number')}"></p>
                        <em></em>
                    </div>
                </div>
            </div>
        </div>
        <div class="input_box">
            <input type="password" name="password" id="password" class="con_inputbox" placeholder="{__('Please enter password')}">
            <div class="error_tipdiv" style="display:none">
                <em class="error_ico"></em>
                <div class="error_tips">
                    <div class="et_con">
                        <p data-default="{__('Please enter password')}"></p>
                        <em></em>
                    </div>
                </div>
            </div>
        </div>

        <div class="input_box">
            <input type="password" name="verifyPassword" id="verifyPassword" class="con_inputbox" placeholder="{__('Retype Password')}">
            <div class="error_tipdiv" style="display:none">
                <em class="error_ico"></em>
                <div class="error_tips">
                    <div class="et_con">
                        <p data-default="{__('Retype Password')}"></p>
                        <em></em>
                    </div>
                </div>
            </div>
        </div>

        <div class="input_box" id="code-box" style="display: none;">
            <input type="text" name="verifyMobilePhone" id="verifyMobilePhone" class="con_inputbox" placeholder="{__('Please enter Phone verification code')}">
            <div class="error_tipdiv" style="display:none">
                <em class="error_ico"></em>
                <div class="error_tips">
                    <div class="et_con">
                        <p data-default="{__('Please enter Phone verification code')}"></p>
                        <em></em>
                    </div>
                </div>
            </div>
        </div>
        <input type="hidden" id="back_act" name="back_act" value=""/>

    </div>

    <input id="getCode" class="foo_btn yel_linear" value="{__('Request for phone verification code')}" type="button">
    <div class="footer" style="text-align:right;">
        <input class="foo_btn yel_linear" id="verifyCode" value="{__('Register')}" type="button">
        {if empty($return_url)}
            <a href="/mobile/login.html" class="turn_link" style="float:none; margin-right:20px;">{__('Login')}</a>
            <a href="/mobile/reset.html" class="turn_link" style="float:none;">{__('Forgot Password')}</a>
        {else}
            <a href="/mobile/login?return_url={$return_url|urlencode}" class="turn_link" style="float:none; margin-right:20px;">{__('Login')}</a>
            <a href="/mobile/reset?return_url={$return_url|urlencode}" class="turn_link" style="float:none;">{__('Forgot Password')}</a>
        {/if}
    </div>
    <div id="mask" class="mask hide"></div>
    <div id="maskLoad" class="maskLoad"><span><img src="/images/loading_circle.gif" /></span></div>
</div>

{include file="mobile/box.tpl"}
