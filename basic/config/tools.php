<?php

function pr($data=array(), $end='', $stop=false)
{
    echo '<pre>';
    print_r($data);
    echo $end;
    if($stop) die;
}

function pd($data=array(), $end='', $stop=true)
{
    echo '<pre>';
    print_r($data);
    echo $end;
    if($stop) die;
}

function __($str='',$params=array(),$dic='mobile') {
    if(Yii::$app->language=='zh_cn'){
        return Yii::t($dic, $str, $params);
    }else{
        return $str;
    }
}