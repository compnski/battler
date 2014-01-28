package com.dreamofninjas.core.app
{
	import avmplus.getQualifiedClassName;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class BaseFlow extends EventDispatcher implements IFlow
	{
		private static const _flowController:GameStateController = new GameStateController();
		private var _active:Boolean = false;
		
		public function get active():Boolean {
			return _active;
		}
		
		public function BaseFlow()
		{
		}
		
		public function Restored(evt:Event):void {
			_active = true;
		}

		public function Suspended():void {
			_active = false;
			
		}
		
		public function onComplete(f:Function):IFlow {
			addEventListener(Event.COMPLETE, f);
			return this;
		}
		
		public function Execute():void {
			_active = true;
//			trace("Default execute for " + getQualifiedClassName(this));
			//Complete();
		}
		
		protected function release():void {
			//flow specific cleanup
		}
		
		protected function Complete(data:Object=null):void {
			_active = false;
			dispatchEvent(new Event(Event.COMPLETE, false, data));
			release();
			removeEventListeners();
		}
		
		protected static function setNextFlow(flow:IFlow):void {
			_flowController.setNextFlow(flow);
		}
			
		public function name():String {
			return getQualifiedClassName(this);
		}
		
	}
}

