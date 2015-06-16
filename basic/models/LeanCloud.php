<?php
namespace app\models;

use Yii;
use yii\base\Exception;

class LeanCloud extends \yii\base\Object
{
    public $config;

    public function init()
    {
        if(empty($this->config)){
            throw new Exception('Please set info: base\\id\\key\\master');
        }
    }

    public function post($class='', $data=array()){
        $uri = $this->config['base'].$class;

        $response = \Httpful\Request::post($uri)
            ->sendsJson()
            ->addHeader('X-AVOSCloud-Application-Id', $this->config['id'])
            ->addHeader('X-AVOSCloud-Application-Key', $this->config['key'])
            ->addHeader('Content-Type', 'application/json')
            ->body( json_encode($data) )
            ->send();
        return $response->body;
    }

    public function get($class='', $data=array(), $where=''){
        if(empty($data)){
            $uri = $this->config['base'].$class;
        }else{
            if(is_array($data)){
                $uri = $this->config['base'].$class.'?'.http_build_query($data);
            }else{
                $uri = $this->config['base'].$class.'?'.$data;
            }
        }
        if(!empty($where)){
            if(strpos($uri, '?') !== false){
                $uri .= '&where='.json_encode($where);
            }else{
                $uri .= '?where='.json_encode($where);
            }
        }

        $response = \Httpful\Request::get($uri)
            ->addHeader('X-AVOSCloud-Application-Id', $this->config['id'])
            ->addHeader('X-AVOSCloud-Application-Key', $this->config['key'])
            ->send();
        return $response->body;
    }

    public function put($class='', $data=array(), $where, $method='', $objectId='', $sessionToken=''){
        $uri = $this->config['base'].$class.'/'.$objectId.'/'.$method;

        if(empty($where) && empty($method)){
            $uri = $this->config['base'].$class;
        }

        if(empty($sessionToken)){
            $response = \Httpful\Request::put($uri)
                ->sendsJson()
                ->addHeader('X-AVOSCloud-Application-Id', $this->config['id'])
                ->addHeader('X-AVOSCloud-Application-Key', $this->config['key'])
                ->addHeader('Content-Type', 'application/json')
                ->body( json_encode($data) )
                ->send();
        }else{
            $response = \Httpful\Request::put($uri)
                ->sendsJson()
                ->addHeader('X-AVOSCloud-Application-Id', $this->config['id'])
                ->addHeader('X-AVOSCloud-Application-Key', $this->config['key'])
                ->addHeader('X-AVOSCloud-Session-Token', $sessionToken)
                ->addHeader('Content-Type', 'application/json')
                ->body( json_encode($data) )
                ->send();
        }

        return $response->body;
    }

}