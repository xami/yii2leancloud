<?php

namespace app\models;

use Yii;

class User extends \yii\base\Model implements \yii\web\IdentityInterface
{
    public $id;
    public $username;
    public $password;
    public $email;
    public $mobilePhoneNumber;
    public $sessionToken;

    /**
     * @inheritdoc
     */
    public static function findIdentity($id)
    {
        $user = Users::findOne($id);
        return empty($user) ? $user->attributes : null;
    }

    /**
     * @inheritdoc
     */
    public static function findIdentityByAccessToken($token, $type = null)
    {
        $user = Users::findOne(['sessionToken'=>$token]);

        if(!empty($user)){
            return $user->attributes;
        }
        return null;
    }

    /**
     * Finds user by username
     *
     * @param  string      $username
     * @return static|null
     */
    public static function findByUsername($username)
    {
        $user = Users::findOne(['username'=>$username]);

        //先本地查询，再接口查询
        if(!empty($user)){
            $this->attributes = $user->attributes;
            return $this;
        }else{
            $user_cloud = Yii::$app->LeanCloud->get('users', ['username'=>$username]);
            if(!empty($user_cloud->results)){
                $user = new Users;
                $user->username = $user_cloud->username;
                $user->email = $user_cloud->email;
                $user->mobilePhoneNumber = $user_cloud->mobilePhoneNumber;
                $user->superuser = 0;
                $user->status = 1;
                $user->create_at = date("Y-m-d H:i:s", strtotime($this->user_info->createdAt));
                $user->lastvisit_at = date("Y-m-d H:i:s", strtotime($this->user_info->updatedAt));
                $user->save();
                $this->attributes = $user->attributes;
                return $this;
            }
        }

        return null;
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
        $r = Yii::$app->LeanCloud->get('login', ['username'=>$this->username, 'password'=>$this->password]);
        if(isset($r->code)){
            return $r;
        }else{
            return true;
        }
    }
}
