<?php

namespace app\models;

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

        if(!empty($user)){
            return $user->attributes;
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

        return $this->password === $password;
    }
}
