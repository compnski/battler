package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.battler.DamageType;
	import com.dreamofninjas.core.app.BaseModel;
	
	public class AttackModel extends BaseModel {

		public var range:int;
		public var type:DamageType;
		public var auras:Object;
		public var name:String;
		public var totalRecoveryTime:int;
		public var damage:int;
		public var attacker:UnitModel;
		
		
		
		public function get faction():String {
			return attacker.faction;
		}
		
		public function AttackModel(attacker:UnitModel, name:String, damage:int, range:int, type:DamageType, recoveryTime:int, auras:Object) {
			super();
			this.attacker = attacker;
			this.damage = damage;
			this.name = name;
			this.range = range;
			this.type = type;
			this.totalRecoveryTime = recoveryTime;
			if (auras == null) {
				auras = {};
			}
			this.auras = auras;
		}
				
		public function getAttackRating():int {
			return damage;	
		}
		
		public function get iconText():String {
			switch(this.type) {
				case DamageType.PHYSICAL:
					return  "⚔";
					break;
				case DamageType.MAGIC:
					return "☥";
					break;
			}
			return "⚾";
		}
	}
}