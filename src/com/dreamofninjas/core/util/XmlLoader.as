package com.dreamofninjas.core.util {
import com.dreamofninjas.core.util.BaseLoader;

import flash.net.URLLoader;
import flash.net.URLRequest;

import flash.events.Event;


public class XmlLoader extends BaseLoader {

    protected var _xmlRequest:URLRequest;
    protected var _xmlLoader:URLLoader;

    function XmlLoader(filename:String) {
        super();
        _xmlRequest = new URLRequest(filename);
    }

    public override function load(timeout:uint=0):void {
        super.load(timeout);
        _xmlLoader = new URLLoader();
        _xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
        _xmlLoader.load(_xmlRequest);
    }

    protected function xmlLoaded(evt:Event):void {
        _xmlLoader.removeEventListener(Event.COMPLETE, xmlLoaded);
        loadComplete(new XML((evt.target as URLLoader).data));
    }
}
}
