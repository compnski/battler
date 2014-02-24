package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.battler.events.UnitEvent;
	import com.dreamofninjas.core.interfaces.IRectangle;
	import com.dreamofninjas.core.ui.GPoint;
	
	import flash.utils.Dictionary;
	
	import starling.events.Event;
	
	public class UnitModel extends BaseUnitModel implements IRectangle
	{
		
		private var _x:int;
		private var _y:int;
		private var _attacks:Array;
		public function get curHP():int { return this._currentHp }
		public function get curMP():int {  return this._currentMp }
		private var _currentHp:int;
		private var _currentMp:int;
		public var faction:String;

		
		public function get attacks():Array {
			return _attacks;
		}

		public var active:Boolean = true;

		public function getX():int { return x; }
		public function getY():int { return y; }
		public function getH():int { return 32; }
		public function getW():int { return 32; }


		public function UnitModel(name:String, faction:String, job:String, x:int, y:int, properties:Dictionary)
		{
			super(name, job, properties);
			this.faction = faction;
			_x = x;
			_y = y;
			this._currentHp = this.MaxHP;
			this._currentMp = this.MaxMP;

			this._attacks = new Array();
			_attacks.push(new AttackModel(this, "Melee", 15, 1,DamageType.PHYSICAL, 15, {}));
			_attacks.push(new AttackModel(this, "Fire 1", 25, 4, DamageType.MAGIC, 25, {}));
			
		}
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
			return "Unit<" + faction + " " + _job + " (" +x + ", " + y + ")>";
		}

		public function distance(u:UnitModel):int {
			return Math.abs(this.r - u.r) + Math.abs(this.c - u.c);
		}
	
		public static function DistanceSort(from:UnitModel):Function {
			return function(a:UnitModel, b:UnitModel):Number {
				return  a.distance(from) - b.distance(from);
			}
		}

		
	}
}