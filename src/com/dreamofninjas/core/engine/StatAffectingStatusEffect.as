package com.dreamofninjas.core.engine {
	
	public class StatAffectingStatusEffect implements IStatAffectingStatusEffect {
		public var amount:int;
		public var type:StatType;

		public function StatAffectingStatusEffect(type:StatType, amt:int) {
			this.type = type;
			this.amount = amt;
		}

		public function getStat():StatType {
			return this.type;
		}

		public function getAmount():int {
			return this.amount;
		}
		
		public function visible():Boolean {
			return true;
		}
		
		public function name():String {
			return "" + amount + " " + type.name;
		}
	}
}
