package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.core.app.BaseModel;
	
	import starling.events.Event;
	
	public class ActionQueue extends BaseModel
	{
		
		private var _queue:Array = new Array();
		private var _now:int = 0;
		
		public function get queue():Array {
			this._queue.sortOn("at", Array.NUMERIC);
			return this._queue;
		}
				
		public function get now():int {
			return _now;
		}
		
		public function ActionQueue()
		{
			super();
		}
		
		public function popNextAction():Action {
			var action:Action = this.queue.shift();
			this._now = action.at;
			trace("now = " + this._now);
			dispatchEvent(new Event(Event.CHANGE));
			return action;
		}
		
		public function enqueue(action:Action):void {
			trace("adding action " + action);
			this._queue.push(action);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
	}
}