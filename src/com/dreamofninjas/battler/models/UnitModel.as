package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.battler.DamageType;
	import com.dreamofninjas.battler.IHasEffects;
	import com.dreamofninjas.battler.IStatusEffect;
	import com.dreamofninjas.battler.StatProperty;
	import com.dreamofninjas.battler.StatType;
	import com.dreamofninjas.core.app.BaseModel;
	import com.dreamofninjas.core.ui.GPoint;

	import flash.utils.Dictionary;

	import starling.events.Event;

	public class UnitModel extends BaseModel implements IHasEffects {
		public static const Builder:Class = UnitModelBuilder;

		private var _x:int;
		private var _y:int;
		private var _attacks:Array;

		public function get attacks():Array {
			return _attacks;
		}

		// Move
		private var _move:StatProperty;
		public function get Move():int {  return this._move.currentValue() }
		public function set Move(amt:int):void { this._move.base = amt; }

		// Str
		private var _str:StatProperty;
		public function get Str():int {  return this._str.currentValue() }
		public function set Str(amt:int):void { this._str.base = amt; }

		// Dex
		private var _dex:StatProperty;
		public function get Dex():int {  return this._dex.currentValue() }
		public function set Dex(amt:int):void { this._dex.base = amt; }

		// Int
		private var _int:StatProperty;
		public function get Int():int {  return this._int.currentValue() }
		public function set Int(amt:int):void { this._int.base = amt; }

		// Fai
		private var _fai:StatProperty;
		public function get Fai():int {  return this._fai.currentValue() }
		public function set Fai(amt:int):void { this._fai.base = amt; }

		// Att
		private var _att:StatProperty;
		public function get Att():int {  return this._att.currentValue() }
		public function set Att(amt:int):void { this._att.base = amt; }

		// Hp
		private var _hp:StatProperty;
		public function get HP():int {  return this._hp.currentValue() }
		public function set HP(amt:int):void { this._hp.base = amt; }

		// Mp
		private var _mp:StatProperty;
		public function get MP():int {  return this._mp.currentValue() }
		public function set MP(amt:int):void { this._mp.base = amt; }

		// Mdef
		private var _mdef:StatProperty;
		public function get MDef():int {  return this._mdef.currentValue() }
		public function set MDef(amt:int):void { this._mdef.base = amt; }

		// Pdef
		private var _pdef:StatProperty;
		public function get PDef():int {  return this._pdef.currentValue() }
		public function set PDef(amt:int):void { this._pdef.base = amt; }

		public var faction:String;
		public var type:String; //class?

		public var name:String;
		public var id:int;

		private var _properties:Dictionary;
		public function UnitModel(name:String, faction:String, type:String, x:int, y:int) {
			this._str = new StatProperty(this, StatType.STR, 0);
			this._int = new StatProperty(this, StatType.INT, 0);
			this._dex = new StatProperty(this, StatType.DEX, 0);
			this._fai = new StatProperty(this, StatType.FAI, 0);
			this._att = new StatProperty(this, StatType.ATT, 0);
			this._hp =  new StatProperty(this, StatType.HP, 0);
			this._mp =  new StatProperty(this, StatType.MP, 0);
			this._pdef = new StatProperty(this, StatType.PDEF, 0);
			this._mdef = new StatProperty(this, StatType.MDEF, 0);
			this._move = new StatProperty(this, StatType.MOVE, 0);

			_x = x;
			_y = y;
			this.faction = faction;
			this.type = type;
			this.name = name;
			this._attacks = new Array();
			_attacks.push(new AttackModel(this, "Melee", 15, 1,DamageType.PHYSICAL, 150, {}));
			_attacks.push(new AttackModel(this, "Fire 1", 25, 14, DamageType.MAGIC, 150, {}));
		}

		private var effects:Vector.<IStatusEffect> = new Vector.<IStatusEffect>();
		public function getEffects():Vector.<IStatusEffect> {
			return effects; //clone?
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

		public function toString():String {
			return "Unit<" + faction + " " + type + " (" +x + ", " + y + ")>";
		}
	}
}
