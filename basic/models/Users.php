<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "users".
 *
 * @property integer $id
 * @property string $username
 * @property string $password
 * @property string $email
 * @property string $mobilePhoneNumber
 * @property string $objectId
 * @property string $sessionToken
 * @property string $activkey
 * @property integer $superuser
 * @property integer $status
 * @property string $create_at
 * @property string $lastvisit_at
 */
class Users extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'users';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
//            [['email', 'mobilePhoneNumber'], 'required'],
            [['superuser', 'status'], 'integer'],
            [['create_at', 'lastvisit_at'], 'safe'],
            [['username'], 'string', 'max' => 32],
            [['password', 'email', 'activkey'], 'string', 'max' => 128],
            [['mobilePhoneNumber','objectId'], 'string', 'max' => 32],
            [['sessionToken','nickname'], 'string', 'max' => 64],
            [['avatar'], 'string', 'max' => 255],
            [['username'], 'unique']
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'username' => 'Username',
            'password' => 'Password',
            'email' => 'Email',
            'mobilePhoneNumber' => 'Mobile Phone Number',
            'objectId' => 'objectId',
            'sessionToken' => 'sessionToken',
            'nickname' => 'Nickname',
            'avatar' => 'Avatar',
            'activkey' => 'Activkey',
            'superuser' => 'Superuser',
            'status' => 'Status',
            'create_at' => 'Create At',
            'lastvisit_at' => 'Lastvisit At',
        ];
    }
}
