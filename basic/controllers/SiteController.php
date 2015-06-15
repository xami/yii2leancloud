<?php

namespace app\controllers;

use Yii;
use yii\filters\AccessControl;
use yii\web\Controller;
use yii\filters\VerbFilter;
use app\models\LoginForm;
use app\models\ContactForm;
use app\assets\AppAsset;

class SiteController extends Controller
{
    public function behaviors()
    {
        return [
            'access' => [
                'class' => AccessControl::className(),
                'only' => ['logout'],
                'rules' => [
                    [
                        'actions' => ['logout'],
                        'allow' => true,
                        'roles' => ['@'],
                    ],
                ],
            ],
            'verbs' => [
                'class' => VerbFilter::className(),
                'actions' => [
                    'logout' => ['post'],
                ],
            ],
        ];
    }

    public function actions()
    {
        return [
            'auth' => [
                'class' => 'yii\authclient\AuthAction',
                'successCallback' => [$this, 'successCallback'],
            ],
            'error' => [
                'class' => 'yii\web\ErrorAction',
            ],
            'captcha' => [
                'class' => 'yii\captcha\CaptchaAction',
                'fixedVerifyCode' => YII_ENV_TEST ? 'testme' : null,
            ],
        ];
    }

    public function successCallback($client)
    {
        $attributes = $client->getUserAttributes();
        \Yii::error(json_encode($attributes));
        // user login or signup comes here
    }


    public $data;
    public function init(){
        parent::init();

        $this->layout = 'mobile.tpl';
        $return_url = Yii::$app->request->get('return_url', '');
        if(empty($return_url)){
            if(isset($_SERVER['HTTP_REFERER'])){
                $purl = parse_url($_SERVER['HTTP_REFERER']);
                if(isset($purl['host']) && !empty($purl['host']) && $purl['host'] != $_SERVER['SERVER_NAME']){
                    $return_url = $_SERVER['HTTP_REFERER'];
                }
            }
        }

        $this->data = [
            'return_url'=>$return_url,
        ];

    }

    public function actionIndex()
    {
        $this->layout = 'main';
        return $this->render('index');
    }

//    public function actionLogin()
//    {
//        if (!\Yii::$app->user->isGuest) {
//            return $this->goHome();
//        }
//
//        $model = new LoginForm();
//        if ($model->load(Yii::$app->request->post()) && $model->login()) {
//            return $this->goBack();
//        }
//        return $this->render('login', [
//            'model' => $model,
//        ]);
//    }

    public function actionLogout()
    {
        $this->layout = 'main';
        Yii::$app->user->logout();

        return $this->goHome();
    }

    public function actionContact()
    {
        $this->layout = 'main';
        $model = new ContactForm();
        if ($model->load(Yii::$app->request->post()) && $model->contact(Yii::$app->params['adminEmail'])) {
            Yii::$app->session->setFlash('contactFormSubmitted');

            return $this->refresh();
        }
        return $this->render('contact', [
            'model' => $model,
        ]);
    }

    public function actionAbout()
    {
        $this->layout = 'main';
        return $this->render('about');
    }



    public function actionLogin(){
        $sso = \yii\authclient\widgets\AuthChoice::widget([ 'baseAuthUrl' => ['site/auth']]);
        $this->data['sso'] = $sso;

        return $this->render('/mobile/login.tpl', $this->data);
    }

    public function actionRegister(){
        return $this->render('/mobile/register.tpl', $this->data);
    }

    public function actionReset(){
        return $this->render('/mobile/reset.tpl', $this->data);
    }

    public function actionAgreement(){

        return $this->render('/mobile/agreement.tpl', $this->data);
    }

    public function actionCReset(){
        $this->layout = '//layouts/api';
        return $this->render('/mobile/creset.tpl', $this->data);
    }

    public function actionCVerify(){
        $this->layout = '//layouts/api';
        return $this->render('/mobile/cverify.tpl', $this->data);
    }
}
