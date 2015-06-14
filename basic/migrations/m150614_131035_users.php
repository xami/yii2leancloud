<?php

use yii\db\Schema;
use yii\db\Migration;

class m150614_131035_users extends Migration
{
    public function up()
    {
        return $this->createTable('users', array(
            'id' => 'int(11) NOT NULL',
            'username' => 'varchar(20) NOT NULL DEFAULT \'\'',
            'password' => 'varchar(128) NOT NULL DEFAULT \'\'',
            'email' => 'varchar(128) NOT NULL',
            'mobilePhoneNumber' => 'varchar(32) NOT NULL',
            'sessionToken' => 'varchar(64) NOT NULL DEFAULT \'\'',
            'activkey' => 'varchar(128) NOT NULL DEFAULT \'\'',
            'superuser' => 'int(1) NOT NULL DEFAULT \'0\'',
            'status' => 'int(1) NOT NULL DEFAULT \'0\'',
            'create_at' => 'timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP',
            'lastvisit_at' => 'timestamp NOT NULL DEFAULT \'0000-00-00 00:00:00\'',
            'PRIMARY KEY (`id`)',
            'UNIQUE KEY `user_username` (`username`)',
        ));
    }

    public function down()
    {
        echo "m150614_131035_users cannot be reverted.\n";

        return $this->dropTable('users');
    }
    
    /*
    // Use safeUp/safeDown to run migration code within a transaction
    public function safeUp()
    {
    }
    
    public function safeDown()
    {
    }
    */
}
