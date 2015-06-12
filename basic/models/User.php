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
        return empty($user) ? $user : null;
    }

    /**
     * @inheritdoc
     */
    public static function findIdentityByAccessToken($token, $type = null)
    {
        $user = Users::findOne(['sessionToken'=>$token]);

        if(!empty($user)){
            return $user;
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

        //只信任直接调取接口的数据
        $user_cloud=new \stdClass();
        $get_cloud = Yii::$app->LeanCloud->get('users', ['username'=>$username]);
        if(isset($get_cloud->results[0])){
            $user_cloud = $get_cloud->results[0];
        }

        //先本地查询，再接口查询
        if(!empty($user)){
            if(!empty($user_cloud)){
                $user->email = isset($user_cloud->email) ? $user_cloud->email : '';
                $user->mobilePhoneNumber = isset($user_cloud->mobilePhoneNumber) ? $user_cloud->mobilePhoneNumber : '';
//                $user->sessionToken = $user_cloud->sessionToken;
                $user->lastvisit_at = date("Y-m-d H:i:s", strtotime($user_cloud->updatedAt));
                if($user->save()){
                    $this->id = $user->id;
                    $this->email = $user_cloud->email;
                    $this->mobilePhoneNumber = $user_cloud->mobilePhoneNumber;
//                    $this->sessionToken = $user_cloud->sessionToken;
                }
                return new ($this);
            }
        }else{
            if(!empty($user_cloud)){
                $user = new Users;
                $user->username = $user_cloud->username;
                $user->email = isset($user_cloud->email) ? $user_cloud->email : '';
                $user->mobilePhoneNumber = isset($user_cloud->mobilePhoneNumber) ? $user_cloud->mobilePhoneNumber : '';
                $user->superuser = 0;
                $user->status = 1;
                $user->create_at = date("Y-m-d H:i:s", strtotime($user_cloud->createdAt));
                $user->lastvisit_at = date("Y-m-d H:i:s", strtotime($user_cloud->updatedAt));
//                $user->sessionToken = $user_cloud->sessionToken;

                if($user->save()){
                    $this->id = $user->id;
                    $this->email = $user_cloud->email;
                    $this->mobilePhoneNumber = $user_cloud->mobilePhoneNumber;
//                    $this->sessionToken = $user_cloud->sessionToken;
                }
                return $this;
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
