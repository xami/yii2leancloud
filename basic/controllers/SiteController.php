<?php

namespace app\controllers;

use Yii;
use yii\filters\AccessControl;
use yii\web\Controller;
use yii\filters\VerbFilter;
use app\models\LoginForm;
use app\models\ContactForm;
use Smarty;

class SiteController extends Controller
{
    public function behaviors()
    {
        return [
            'access' => [
                'class' => AccessControl::className(),
                'only' => ['logout','agreement','register','reset','creset','cverify'],
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
            'error' => [
                'class' => 'yii\web\ErrorAction',
            ],
            'captcha' => [
                'class' => 'yii\captcha\CaptchaAction',
                'fixedVerifyCode' => YII_ENV_TEST ? 'testme' : null,
            ],
        ];
    }


    public $smarty;
    public function init(){
        parent::init();

        $this->layout = '/mobile/m';
        $return_url = Yii::$app->request->get('return_url', '');
        if(empty($return_url)){
            if(isset($_SERVER['HTTP_REFERER'])){
                $purl = parse_url($_SERVER['HTTP_REFERER']);
                if(isset($purl['host']) && !empty($purl['host']) && $purl['host'] != $_SERVER['SERVER_NAME']){
                    $return_url = $_SERVER['HTTP_REFERER'];
                }
            }
        }

        $this->view->beforeRender();

        pd(Yii::$app->view->renderers['tpl']);
        Yii::$app->view->renderers['tpl'] = Yii::createObject(Yii::$app->view->renderers['tpl']);
        $this->smarty = Yii::$app->smarty;
        $this->smarty->assign('return_url',$return_url);
    }

    public function actionIndex()
    {
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
        Yii::$app->user->logout();

        return $this->goHome();
    }

    public function actionContact()
    {
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
        return $this->render('about');
    }



    public function actionLogin(){

        $this->render('/mobile/login.tpl');
    }

    public function actionRegister(){

        $this->render('/mobile/register');
    }

    public function actionReset(){
        $this->render('/mobile/reset');
    }

    public function actionAgreement(){

        $this->render('/mobile/agreement');
    }

    public function actionCReset(){
        $this->layout = '//layouts/api';
        $this->render('/mobile/creset');
    }

    public function actionCVerify(){
        $this->layout = '//layouts/api';
        $this->render('/mobile/cverify');
    }
}
