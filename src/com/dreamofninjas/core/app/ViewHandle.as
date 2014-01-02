package com.dreamofninjas.core.app
{
	public interface ViewHandle
	{
		function show():void;
		function hide():void;
		function dispose():void;
		function removeFromParent(dispose:Boolean = false):void;
		function addEventListener(type:String, listener:Function):void;
		function removeEventListener(type:String, listener:Function):void;		
	}
}