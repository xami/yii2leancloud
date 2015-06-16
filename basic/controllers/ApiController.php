<?php

namespace app\controllers;

use app\models\LoginForm;
use app\models\User;
use Yii;
use yii\filters\AccessControl;
use yii\web\Controller;
use yii\filters\VerbFilter;
use app\models\LeanCloud;

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
                if(Yii::$app->user->id > 0){
                    $identity = Yii::$app->user->identity;
                    $r = $c->put($class, $data, $where, $method, $identity->objectId, $identity->sessionToken);
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
                // 接口验证登陆成功
                if(isset($r->sessionToken) && isset($r->objectId)){
                    $r->rememberMe = $data['rememberMe'];
                    $r->password = $data['password'];
                    // 实现本地登录
                    $model=new LoginForm();
                    if ($model->load($r,'users')->login($r->sessionToken)) {

                    }else{

                    }
                }
            }
        }

        echo json_encode($r);
    }

    public function actionUser(){
        echo Yii::$app->user->id;
    }


}
