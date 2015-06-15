<?php

$params = require(__DIR__ . '/params.php');

$config = [
    'id' => 'basic',
    'basePath' => dirname(__DIR__),
    'bootstrap' => ['log'],
    'components' => [
        'urlManager'=>[
            'class' => 'yii\web\UrlManager',
            'enablePrettyUrl'=>true,
            'showScriptName' => false,
            'enableStrictParsing'=>false,
            'suffix'=>'.html',
            'rules'=>[
                "<controller:\w+>/<action:\w+>/<id:\d+>"=>"<controller>/<action>",
                "<controller:\w+>/<action:\w+>"=>"<controller>/<action>"
            ],
        ],
        'authManager' => [
            'class' => 'yii\rbac\DbManager',
        ],
        'request' => [
            // !!! insert a secret key in the following (if it is empty) - this is required by cookie validation
            'cookieValidationKey' => 'b96HJExAdPcKvPLkMZGJEJbN3OoxFLmN',
        ],
        'cache' => [
            'class' => 'yii\caching\FileCache',
        ],
        'user' => [
            'identityClass' => 'app\models\User',
            'enableAutoLogin' => true,
        ],
        'errorHandler' => [
            'errorAction' => 'site/error',
        ],
        'mailer' => [
            'class' => 'yii\swiftmailer\Mailer',
            // send all mails to a file by default. You have to set
            // 'useFileTransport' to false and configure a transport
            // for the mailer to send real emails.
            'useFileTransport' => true,
        ],
        'log' => [
            'traceLevel' => YII_DEBUG ? 3 : 0,
            'targets' => [
                [
                    'class' => 'yii\log\FileTarget',
                    'levels' => ['error', 'warning'],
                ],
            ],
        ],
        'LeanCloud' => [
            'class' => 'app\models\LeanCloud',
            'config' => [
                'base'=>'https://api.leancloud.cn/1.1/',
                'id'=>'2oiv7k7rslom701edx7ccit3jp9zy3z9k4jz351fb0cqvem0',
                'key'=>'yxp2mqqv8i0p02b4cukh1fz68cn9yz43xb27elopbtuugqhp',
                'master'=>'58rze1s4ahf41zdqhvfcf800cm65e6isidwkfe2llgx9bfj9',
            ]
        ],
        'view' => [
            'renderers' => [
                'tpl' => [
//                    'class' => 'yii\smarty\ViewRenderer',
                    'class' => 'yii\smarty\ViewRenderer',
                    //'cachePath' => '@runtime/Smarty/cache',
                ],
                'twig' => [
                    'class' => 'yii\twig\ViewRenderer',
                    'cachePath' => '@runtime/Twig/cache',
                    // Array of twig options:
                    'options' => [
                        'auto_reload' => true,
                    ],
                    'globals' => ['html' => '\yii\helpers\Html'],
                    'uses' => ['yii\bootstrap'],
                ],
            ],
        ],
        'authClientCollection' => [
            'class' => 'yii\authclient\Collection',
            'clients' => [
                'google' => [
                    'class' => 'yii\authclient\clients\GoogleOpenId'
                ],
                'facebook' => [
                    'class' => 'yii\authclient\clients\Facebook',
                    'clientId' => '432998553536558',
                    'clientSecret' => '88cdfea142efcb079a70e21b36fd5855',
                ],
                'qq' => [
                    'class'=>'app\models\QqOAuth',
                    'clientId'=>'101222737',
                    'clientSecret'=>'02174f9b2f5ddcff31309fb85306f4ad'
                ],
            ],
        ],
        'db' => require(__DIR__ . '/db.php'),
    ],
    'params' => $params,
];

if (YII_ENV_DEV) {
    // configuration adjustments for 'dev' environment
    $config['bootstrap'][] = 'debug';
    $config['modules']['debug'] = 'yii\debug\Module';

    $config['bootstrap'][] = 'gii';
    $config['modules']['gii']['class'] = 'yii\gii\Module';
    $config['modules']['gii']['allowedIPs'] = ['127.0.0.1', '::1', '192.168.0.*', '10.0.2.*'];
}

include_once(__DIR__.'/tools.php');

return $config;
