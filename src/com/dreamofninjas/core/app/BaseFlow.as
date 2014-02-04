package com.dreamofninjas.core.app
{
	import com.dreamofninjas.core.engine.GameStateController;
	import com.dreamofninjas.core.interfaces.IFlow;
	
	import avmplus.getQualifiedClassName;
	
	import starling.animation.DelayedCall;
	import starling.animation.Juggler;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class BaseFlow extends EventDispatcher implements IFlow
	{
		private static const _flowController:GameStateController = new GameStateController();
		private var _active:Boolean = false;
		private var _onNextRestoreCallback:Function;
		
		public function get active():Boolean {
			return _active;
		}
		
		public function BaseFlow()
		{
		}
		
		public function Restored(evt:Event):void {
			_active = true;
			if (this._onNextRestoreCallback) {
				var cb:Function = this._onNextRestoreCallback;
				this._onNextRestoreCallback = null;
				cb(evt);
			}
		}

		public function Suspended():void {
			_active = false;
			
		}
		
		// If this is called, call this function after being restored.
		// Easy way to chain 
			
		protected function onRestored(callback:Function):void {
			this._onNextRestoreCallback = callback;
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
		
		protected function DelayedComplete(delay:Number, data:Object=null):DelayedCall {
			_active = false;
			return juggler.delayCall(Complete, delay, data);
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
		
		protected function get juggler():Juggler {
			return _flowController.juggler;
		}
		
	}
}

