package com.dreamofninjas.battler
{
	import flash.utils.Dictionary;

	public class UnitModelBuilder {
		private var _x:int;
		private var _y:int;
		private var _faction:String;
		private var _type:String;
		private var _properties:Dictionary = new Dictionary();

		public function UnitModelBuilder(faction:String, type:String, x:int, y:int) {
			_properties["TYPE"] = type;
			_properties["NAME"] = type;
			_properties["FACTION"] = faction;
			_faction = faction;
			_type = type;
			_x = x;
			_y = y;
		}

		public function withAtk(amt:int):UnitModelBuilder {
			_properties["ATK"] = amt;
			return this;
		}

		public function withSpd(amt:int):UnitModelBuilder {
			_properties["SPD"] = amt;
			return this;
		}

		public function withDef(amt:int):UnitModelBuilder {
			_properties["DEF"] = amt;
			return this;
		}

		public function withHp(amt:int):UnitModelBuilder {
			_properties["HP"] = amt;
			return this;
		}

		public function withMp(amt:int):UnitModelBuilder {
			_properties["MP"] = amt;
			return this;
		}

		public function withName(name:String):UnitModelBuilder {
			_properties["NAME"] = name;
			return this;
		}
		public function withCharId(id:int):UnitModelBuilder {
			_properties["CHAR_ID"] = id;
			return this;
		}
		public function build():UnitModel {
			return new UnitModel(_faction, _type, _x, _y, _properties);
		}
	}
}