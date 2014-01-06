package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.core.app.BaseModel;
	
	public class AttackModel extends BaseModel {

		public var range:int;
		public var type:DamageType;
		public var auras:Object;
		public var name:String;
		public var totalRecoveryTime:int;
		
		public static function NewPhysicalAttack(name:String, range:int, recoveryTime:int, auras:Object=null):AttackModel {
			return new AttackModel(name, range, DamageType.PHYSICAL, recoveryTime, auras);
		}
		
		public static function NewMagicAttack(name:String, range:int, castTime:int, recoveryTime:int, auras:Object=null):AttackModel {
			return new AttackModel(name, range, DamageType.MAGIC, castTime + recoveryTime, auras);
		}
		
		public function AttackModel(name:String, range:int, type:DamageType, recoveryTime:int, auras:Object) {
			super();
			this.name = name;
			this.range = range;
			this.type = type;
			this.totalRecoveryTime = recoveryTime;
			if (auras == null) {
				auras = {};
			}
			this.auras = auras;
		}
		
		public function calculateDamage(target:UnitModel):int {
			return 0;	
		}
		
	}
}

internal class DamageType {
	public static const PHYSICAL:DamageType = new DamageType(0);
	public static const MAGIC:DamageType = new DamageType(1);
	
	private var id:int;
	
	function DamageType(id:int) {
		this.id = id;
	}
	
	public function toString():String {
		return this.id.toString();
	}
}