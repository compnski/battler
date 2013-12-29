package com.dreamofninjas.battler
{
	import starling.events.Event;
	
	public class TileEvent extends Event {
		
		public static const CLICKED:String = "clicked";
		
		public var x:int;
		public var y:int;
		public var r:int;
		public var c:int;
		
		public function TileEvent(type:String, x:int, y:int, bubbles:Boolean=false, data:Object=null)
		{
			this.x = x;
			this.y = y;
			this.r = Math.floor(y / 32);
			this.c = Math.floor(x / 32);
			super(type, bubbles, data);
		}
	}
}