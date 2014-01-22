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

	//TODO: Merge this and the builder, remove most of the setters for stats
	
	public class UnitModel extends BaseModel implements IHasEffects {
		public static const Builder:Class = UnitModelBuilder;

		private var _x:int;
		private var _y:int;
		private var _attacks:Array;

		public function get attacks():Array {
			return _attacks;
		}

		private var _move:StatProperty;
		public function get Move():int {  return this._move.currentValue() }

		private var _str:StatProperty;
		public function get Str():int {  return this._str.currentValue() }

		private var _dex:StatProperty;
		public function get Dex():int {  return this._dex.currentValue() }

		private var _int:StatProperty;
		public function get Int():int {  return this._int.currentValue() }

		private var _fai:StatProperty;
		public function get Fai():int {  return this._fai.currentValue() }

		private var _att:StatProperty;
		public function get Att():int {  return this._att.currentValue() }

		private var _hp:StatProperty;
		public function get MaxHP():int {  return this._hp.currentValue() }
		public function get HP():int { return this._currentHp }
		
		private var _mp:StatProperty;
		public function get MP():int {  return this._mp.currentValue() }

		private var _mdef:StatProperty;
		public function get MDef():int {  return this._mdef.currentValue() }

		private var _pdef:StatProperty;
		public function get PDef():int {  return this._pdef.currentValue() }

		private var _currentHp:int;
		
		public var faction:String;
		public var type:String; //class?

		public var name:String;
		public var id:int;

		// Returns true if the unit takes lethal damage
		public function takeDamage(amt:int):Boolean {
			this._currentHp -= amt;
			return this._currentHp <= 0;
		}
		
		private var _properties:Dictionary;
		public function UnitModel(name:String, faction:String, type:String, x:int, y:int, properties:Dictionary) {
			this._str = new StatProperty(this, StatType.STR, properties[StatType.STR]);
			this._int = new StatProperty(this, StatType.INT, properties[StatType.INT]);
			this._dex = new StatProperty(this, StatType.DEX, properties[StatType.DEX]);
			this._fai = new StatProperty(this, StatType.FAI, properties[StatType.FAI]);
			this._att = new StatProperty(this, StatType.ATT, properties[StatType.ATT]);
			this._hp =  new StatProperty(this, StatType.HP, properties[StatType.HP]);
			this._mp =  new StatProperty(this, StatType.MP, properties[StatType.MP]);
			this._pdef = new StatProperty(this, StatType.PDEF, properties[StatType.PDEF]);
			this._mdef = new StatProperty(this, StatType.MDEF, properties[StatType.MDEF]);
			this._move = new StatProperty(this, StatType.MOVE, properties[StatType.MOVE]);
			this._currentHp = this.MaxHP;
			
			_x = x;
			_y = y;
			this.faction = faction;
			this.type = type;
			this.name = name;
			this._attacks = new Array();
			_attacks.push(new AttackModel(this, "Melee", 15, 1,DamageType.PHYSICAL, 150, {}));
			_attacks.push(new AttackModel(this, "Fire 1", 25, 4, DamageType.MAGIC, 150, {}));
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
