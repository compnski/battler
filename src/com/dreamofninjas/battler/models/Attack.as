package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.core.app.BaseModel;
	
	public class Attack extends BaseModel {

		public var range:int;
		public var type:DamageType;
		public var auras:Object;
		
		
		public function calculateDamage(target:UnitModel):int {
			return 0;	
		}
		
		public function Attack() {
			super();
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