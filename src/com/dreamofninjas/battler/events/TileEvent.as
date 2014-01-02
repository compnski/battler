package com.dreamofninjas.battler.events
{
	import starling.events.Event;
	
	public class TileEvent extends Event {
		
		public static const CLICKED:String = "clicked";
		
		public function TileEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}