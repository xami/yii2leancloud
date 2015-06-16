    {use class="yii\helpers\Html"}{use class="app\assets\AppAsset"}{AppAsset::register($this)|void}{$this->beginPage()}<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no" />
    <meta name="format-detection" content="telephone=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <link rel="stylesheet" type="text/css" href="/css/login.css"/>
    <script src="/js/jQuery.js"></script>
    <script type="text/javascript">
        (function(){
            var sUserAgent = navigator.userAgent;
            if (sUserAgent.indexOf('Android') > -1 || sUserAgent.indexOf('iPhone') > -1 || sUserAgent.indexOf('iPad') > -1 || sUserAgent.indexOf('iPod') > -1 || sUserAgent.indexOf('Symbian') > -1){

            }else{
                //location.href = 'http://';
            }
        })();
    </script>
    {$this->head()}
</head>
<body>
{$this->beginBody()}

{$content}

{$this->endBody()}
</body>
</html>
{$this->endPage()}