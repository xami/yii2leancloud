<?php

namespace app\controllers;

use Yii;
use yii\filters\AccessControl;
use yii\web\Controller;
use yii\filters\VerbFilter;

class ApiController extends \yii\web\Controller
{
    public function init(){
        //去除脚本执行时间限制
        set_time_limit(0);
        parent::init();
    }

    public function actionIndex()
    {
        return $this->render('index');
    }

    public function actionRest(){
        $class = Yii::$app->request->get('class', '');
        $method = Yii::$app->request->get('method', '');
        $type = Yii::$app->request->get('type', 'get');
        $data = Yii::$app->request->get('data', '');
        $where = Yii::$app->request->get('where', '');

        $r = array();
        $c = Yii::$app->LeanCloud;
        if($type == 'put'){
            //修改密码
            if($class=='users' && $method=='updatePassword'){
                if(Yii::app()->user->id > 0){
                    $objectId = Yii::app()->user->getState('objectId');
                    $sessionToken = Yii::app()->user->getState('sessionToken');
                    $r = $c->put($class, $data, $where, $method, $objectId, $sessionToken);
                }else{
                    $r = new stdClass();
                    $r->code = '403';
                    $r->error = 'Unauthorized';
                    echo json_encode($r);
                    return;
                }
            }
        }

        if(empty($r)){
            $r = $c->{$type}($class, $data, $where, $method);
        }


        //处理登陆,绕过有登陆则直接取登陆信息
        if($type=='get' && $class=='login'){
            if(!isset($r->code)){
                //重新登陆
                if(isset($r->sessionToken) && isset($r->objectId)){
                    // 绕过登陆机制
                    $identity=new CleanIdentity($r);
                    // 把用户username、objectId存model里面
                    $identity->authenticate($r);
                    $duration=$data['rememberMe'] ? Yii::app()->user->rememberMeTime : Yii::app()->params['login_time'];
                    Yii::app()->user->login($identity, $duration);
                    foreach ($r as $attrName=>$attrValue) {
                        Yii::app()->user->setState($attrName,$attrValue);
                    }
                }else{

                }
            }
        }

        echo json_encode($r);
    }





}
