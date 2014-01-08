package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.battler.DamageType;
	import com.dreamofninjas.core.app.BaseModel;
	import com.dreamofninjas.core.ui.GPoint;
	
	import flash.utils.Dictionary;
	
	import starling.events.Event;

	public class UnitModel extends BaseModel {
		public static const Builder:Class = UnitModelBuilder;

		private var _x:int;
		private var _y:int;
		private var _attacks:Array;
		public var move:int = 6;

		public function get attacks():Array {
			return _attacks;
		}
		
		public var Str:int;
		public var Int:int;
		public var Dex:int;
		public var Fai:int;
		public var Spd:int;
		public var HP:int;
		public var MP:int;
		public var MDef:int;
		public var PDef:int;
		
		public var faction:String;
		public var type:String;

		public var name:String;
		public var id:int;
		
		private var _properties:Dictionary;
		public function UnitModel(faction:String, type:String, x:int, y:int) {
			_x = x;
			_y = y;
			this.faction = faction;
			this.type = type;
			this._attacks = new Array();
			_attacks.push(new AttackModel(this, "Melee", 15, 1,DamageType.PHYSICAL, 150, {}));
			_attacks.push(new AttackModel(this, "Fire 1", 25, 14, DamageType.MAGIC, 150, {}));
		}
		
		public function get gpoint():GPoint {
			return GPoint.g(r, c);
		}
		
		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function get r():int {
			return y / 32;
		}
		
		public function set r(amt:int):void {
			y = amt * 32;
		}
		
		public function get c():int {
			return x / 32; 
		}

		public function set c(amt:int):void {
			x = amt * 32;
		}

		public function get speed():int {
			return Spd;
		}
		
		public function set speed(amt:int):void {
			Spd = amt;
		}
	

		public function toString():String {
			return "Unit<" + faction + " " + type + " (" +x + ", " + y + ")>";
		}
	}
}
