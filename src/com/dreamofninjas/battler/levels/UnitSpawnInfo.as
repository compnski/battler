package com.dreamofninjas.battler.levels
{
		public class UnitSpawnInfo {
			public var faction:String;
			public var groups:Vector.<String>;
			public var type:String;
			public var name:String;
			public var x:int;
			public var y:int;
			public var active:Boolean;
			//active? properties?
		public function UnitSpawnInfo(x:int, y:int)
		{
			this.x = x;
			this.y = y;
		}
	}
}