<?php
/**
 * Created by PhpStorm.
 * User: admin
 * Date: 2015/6/12
 * Time: 18:04
 */
namespace app\models;

use Yii;
use yii\base\Exception;

class Smarty extends yii\smarty\ViewRenderer
{
    public function getSmarty(){
        if(empty($this->smarty)){
            $this->init();
        }
        return $this->smarty;
    }
}