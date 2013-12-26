package com.dreamofninjas.core.util
{

	import starling.events.Event;
	import starling.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class BaseLoader extends EventDispatcher implements ILoadable
	{
		private var _timer:Timer;

		public function BaseLoader()
		{
		}

		public function load(timeout:uint=0):void
		{
			if (timeout > 0) {
				_timer = new Timer(timeout, 1);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timeoutHandler);
				_timer.start();
			}
		}

		protected function timeoutHandler(ev:TimerEvent):void {

		}

		protected function loadComplete(data:Object=null):void {
			dispatchEvent(new Event(Event.COMPLETE, false, data));
			removeEventListeners();
		}
		protected function loadFailed(msg:String):void {
			dispatchEvent(new Event(Event.CANCEL, false, msg));
			removeEventListeners();
		}
	}
}
