package com.dreamofninjas.core.interfaces
{

public interface ILoadable {
    function load(timeout:uint=0):void;
	function addEventListener(type:String, listener:Function):void;
	function removeEventListener(type:String, listener:Function):void;
	function removeEventListeners(type:String=null):void;
}
}