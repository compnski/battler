package com.dreamofninjas.battler.events
{
	import starling.events.Event;
	
	public class LevelEvent extends Event
	{
		public static const LOAD_MAP:String = "load_map";
		public static const EXIT_MAP:String = "exit";
		public function LevelEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}