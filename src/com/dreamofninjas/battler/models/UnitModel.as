package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.battler.events.UnitEvent;
	import com.dreamofninjas.core.app.BaseModel;
	import com.dreamofninjas.core.engine.StatProperty;
	import com.dreamofninjas.core.engine.StatType;
	import com.dreamofninjas.core.interfaces.IHasEffects;
	import com.dreamofninjas.core.interfaces.IRectangle;
	import com.dreamofninjas.core.interfaces.IStatusEffect;
	import com.dreamofninjas.core.ui.GPoint;
	
	import flash.utils.Dictionary;
	
	import starling.events.Event;

	//TODO: Merge this and the builder, remove most of the setters for stats
	
	public class UnitModel extends BaseModel implements IHasEffects, IRectangle {
		public static const Builder:Class = UnitModelBuilder;
	
		public static const STR:StatType = new StatType("str");
		public static const INT:StatType = new StatType("dex");
		public static const DEX:StatType = new StatType("int");
		public static const FAI:StatType = new StatType("fai");

		public static const PDEF:StatType = new StatType("pdef");
		public static const MDEF:StatType = new StatType("mdef");

		public static const HP:StatType = new StatType("hp");
		public static const MP:StatType = new StatType("mp");
		public static const ATT:StatType = new StatType("att");

		public static const MOVE:StatType = new StatType("move");

		private var _x:int;
		private var _y:int;
		private var _attacks:Array;

		public function get attacks():Array {
			return _attacks;
		}

		public var active:Boolean = true;
		
		public function getX():int { return x; }
		public function getY():int { return y; }
		public function getH():int { return 32; }
		public function getW():int { return 32; }

		
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
		public function get curHP():int { return this._currentHp }
		
		private var _mp:StatProperty;
		public function get MaxMP():int {  return this._mp.currentValue() }
		public function get curMP():int {  return this._currentMp }

		private var _mdef:StatProperty;
		public function get MDef():int {  return this._mdef.currentValue() }

		private var _pdef:StatProperty;
		public function get PDef():int {  return this._pdef.currentValue() }

		private var _currentHp:int;
		private var _currentMp:int;
	
		public var faction:String;
		public var type:String; //class?

		public var name:String;
		public var id:int;
		private static var __id:int = 0;
		
		public var recoveryTime:int = 50;
		

		// Returns true if the unit takes lethal damage
		public function takeDamage(amt:int):Boolean {
			this._currentHp -= amt;
			if (this._currentHp <= 0) {
				this.active = false;
				dispatchEvent(new Event(UnitEvent.DIED));
				return true
			}
			dispatchEvent(new Event(Event.CHANGE, curHP));
			return false
		}
		
		private var _properties:Dictionary;
		public function UnitModel(name:String, faction:String, type:String, x:int, y:int, properties:Dictionary) {
			this.id = UnitModel.__id++;
			this._str = new StatProperty(this, STR, properties[STR]);
			this._int = new StatProperty(this, INT, properties[INT]);
			this._dex = new StatProperty(this, DEX, properties[DEX]);
			this._fai = new StatProperty(this, FAI, properties[FAI]);
			this._att = new StatProperty(this, ATT, properties[ATT]);
			this._hp =  new StatProperty(this, HP , properties[HP]);
			this._mp =  new StatProperty(this, MP , properties[MP]);
			this._pdef = new StatProperty(this, PDEF, properties[PDEF]);
			this._mdef = new StatProperty(this, MDEF, properties[MDEF]);
			this._move = new StatProperty(this, MOVE, properties[MOVE]);
			this._currentHp = this.MaxHP;
			this._currentMp = this.MaxMP;
			
			_x = x;
			_y = y;
			this.faction = faction;
			this.type = type;
			this.name = name;
			this._attacks = new Array();
			_attacks.push(new AttackModel(this, "Melee", 15, 1,DamageType.PHYSICAL, 15, {}));
			_attacks.push(new AttackModel(this, "Fire 1", 25, 4, DamageType.MAGIC, 25, {}));
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
		
		public function distance(u:UnitModel):int {
			return Math.abs(this.r - u.r) + Math.abs(this.c - u.c);
		}
		
		////static
		
		public static function Filter(filter:Function):Function {
			return function(u:UnitModel, idx:int, v:Vector.<UnitModel>):Boolean {
				return filter(u);
			}
		}	
		
		public static function DistanceSort(from:UnitModel):Function {
			return function(a:UnitModel, b:UnitModel):Number {
				return  a.distance(from) - b.distance(from);
			}
		}	
		
	}
}
