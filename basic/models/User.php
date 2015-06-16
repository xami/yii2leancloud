<?php

namespace app\models;

use Yii;

class User extends \yii\base\Model implements \yii\web\IdentityInterface
{
    public $id;
    public $username;
    public $password;
    public $email;
    public $activkey;
    public $superuser;
    public $status;
    public $create_at;
    public $lastvisit_at;
    public $mobilePhoneNumber;
    public $sessionToken;
    public $objectId;
    public $nickname;
    public $avatar;

    /**
     * @inheritdoc
     */
    public static function findIdentity($id)
    {
//        pr('findIdentity');
        $user = Users::findOne($id);

        $model = new self();
        if(!empty($user)){
            $model->setAttributes($user->attributes, false);
        }
        return !empty($model) ? $model : null;
    }

    /**
     * @inheritdoc
     */
    public static function findIdentityByAccessToken($token, $type = null)
    {
        $user = Users::findOne(['sessionToken'=>$token]);

        $model = new self();
        if(!empty($user)){
            $model->setAttributes($user->attributes, false);
        }
        return !empty($model) ? $model : null;
    }

    /**
     * Finds user by username
     *
     * @param  string      $username
     * @return static|null
     */
    public static function findByUsername($username)
    {
//        pr('findByUsername');
        $user = Users::findOne(['username'=>$username]);

        //只信任直接调取接口的数据
        $user_cloud=new \stdClass();
        $get_cloud = Yii::$app->LeanCloud->get('users', ['username'=>$username]);
        if(isset($get_cloud->results[0])){
            $user_cloud = $get_cloud->results[0];
        }

        $model = new self();


        //先本地查询，再接口查询
        if(!empty($user)){
            if(!empty($user_cloud)){
                $user->objectId = $user_cloud->objectId;
                $user->email = isset($user_cloud->email) ? $user_cloud->email : '';
                $user->mobilePhoneNumber = isset($user_cloud->mobilePhoneNumber) ? $user_cloud->mobilePhoneNumber : '';
                $user->lastvisit_at = date("Y-m-d H:i:s", strtotime($user_cloud->updatedAt));

                if($user->save()){
                    $model->setAttributes($user->attributes, false);
                }
                return $model;
            }
        }else{
            if(!empty($user_cloud)){
                $user = new Users;
                $user->username = $user_cloud->username;
                $user->objectId = $user_cloud->objectId;
                $user->email = isset($user_cloud->email) ? $user_cloud->email : '';
                $user->mobilePhoneNumber = isset($user_cloud->mobilePhoneNumber) ? $user_cloud->mobilePhoneNumber : '';
                $user->superuser = 0;
                $user->status = 1;
                $user->create_at = date("Y-m-d H:i:s", strtotime($user_cloud->createdAt));
                $user->lastvisit_at = date("Y-m-d H:i:s", strtotime($user_cloud->updatedAt));

                if($user->save()){
                    $model->setAttributes($user->attributes, false);
                }
                return $model;
            }
        }

        return false;
    }

    /**
     * @inheritdoc
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * @inheritdoc
     */
    public function getAuthKey()
    {
        return $this->sessionToken;
    }

    /**
     * @inheritdoc
     */
    public function validateAuthKey($authKey)
    {
//        pr('validateAuthKey');
        return $this->sessionToken === $authKey;
    }

    /**
     * Validates password
     *
     * @param  string  $password password to validate
     * @return boolean if password provided is valid for current user
     */
    public function validatePassword($password)
    {
//        pr('validatePassword');
        $r = Yii::$app->LeanCloud->get('login', ['username'=>$this->username, 'password'=>$password]);
        if(isset($r->code)){
            return $r;
        }else{
            return true;
        }
    }

    public function save(){
        $user = Users::findOne(['username'=>$this->username]);
        if(!empty($user)){
            $user->sessionToken = $this->sessionToken;
            $user->save();
        }
    }
}
