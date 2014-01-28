package com.dreamofninjas.battler.events
{
	import starling.events.Event;
	
	public class UnitEvent extends Event
	{
		public static const DIED:String = "died";
		public function UnitEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}