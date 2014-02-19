package com.dreamofninjas.core.app
{
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	public class BaseModel extends EventDispatcher
	{
		public function BaseModel()
		{
			super();
		}
		
		protected function dispatchEventIfBubbles(evt:Event):void {
			if (evt.bubbles) {
				dispatchEvent(evt);
			}
		}
	}
}