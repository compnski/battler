package com.dreamofninjas.core.interfaces
{
	import starling.events.Event;

	public interface IFlow
	{
		
		function onComplete(callback:Function):IFlow;
		function Execute():void;
		function Suspended():void;
		function Restored(evt:Event):void;
		function name():String;
	}
}