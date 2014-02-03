package com.dreamofninjas.battler.models
{
	import flash.utils.Dictionary;
	
	public class AiUnitModel extends UnitModel
	{
		public var groups:Vector.<String>;
		public var active:Boolean = false;
		
		public function activate(bool:Boolean):void {
			this.active = bool;
		}

		public function AiUnitModel(name:String, faction:String, type:String, x:int, y:int, properties:Dictionary)
		{
			super(name, faction, type, x, y, properties);
		}		
	}
}