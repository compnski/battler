package com.dreamofninjas.battler
{
	import avmplus.getQualifiedClassName;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class BaseFlow extends EventDispatcher implements IFlow
	{
		private static const _flowController:GameStateController = new GameStateController();
		
		public function BaseFlow()
		{
		}
		
		public function Restored(evt:Event):void {
			
		}
		public function Suspended():void {
			
		}
		
		public function onComplete(f:Function):IFlow {
			addEventListener(Event.COMPLETE, f);
			return this;
		}
		
		public function Execute():void {
			trace("Default execute for " + getQualifiedClassName(this));
			Complete();
		}
		
		protected function Complete():void {
			dispatchEvent(new Event(Event.COMPLETE));
			removeEventListeners();
		}
		
		protected static function setNextFlow(flow:IFlow):void {
			_flowController.setNextFlow(flow);
		}
			
		
	}
}