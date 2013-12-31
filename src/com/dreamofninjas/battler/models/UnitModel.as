package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.core.app.BaseModel;
	
	import flash.utils.Dictionary;
	
	import starling.events.Event;
	import com.dreamofninjas.battler.UnitModelBuilder;

	public class UnitModel extends BaseModel {
		public static const Builder:Class = UnitModelBuilder;

		private var _x:int;
		private var _y:int;

		public var move:int = 6;
		
		private var _properties:Dictionary;
		public function UnitModel(faction:String, type:String, x:int, y:int, properties:Dictionary) {
			super();
			_properties = properties;
			_properties["FACTION"] = faction;
			_properties["TYPE"] = type;
			_x = x;
			_y = y;
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
			return _properties["SPD"];
		}
		
		public function set speed(amt:int):void {
			_properties["SPD"] = amt;
		}
	
		public function get faction():String {
			return _properties["FACTION"];
		}

		public function get type():String {
			return _properties["TYPE"];
		}

		public function toString():String {
			return "Unit<" + faction + " " + type + " (" +x + ", " + y + ")>";
		}
	}
}
