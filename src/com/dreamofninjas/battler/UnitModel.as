package com.dreamofninjas.battler
{
	import com.dreamofninjas.core.app.BaseModel;
	
	import flash.utils.Dictionary;
	
	public class UnitModel extends BaseModel {
		public static const Builder:Class = UnitModelBuilder;

		public var x:int;
		public var y:int;
		
		private var _properties:Dictionary;
		public function UnitModel(faction:String, type:String, x:int, y:int, properties:Dictionary) {
			super();
			_properties = properties;
			_properties["FACTION"] = faction;
			_properties["TYPE"] = type;
			this.x = x;
			this.y = y;
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


