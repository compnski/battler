package com.dreamofninjas.battler
{
	import com.dreamofninjas.battler.models.AttackModel;
	import com.dreamofninjas.battler.models.UnitModel;

	public class AttackUtils
	{
		public function AttackUtils() {
		}
		
		public static function canAttack(attack:AttackModel, target:UnitModel):Boolean {
				return attack.faction != target.faction;
		}
		
		public static function calculateDamage(attack:AttackModel, target:UnitModel): int {
			switch(attack.type) {
			case DamageType.PHYSICAL:
				return Math.max(0, attack.getAttackRating() - target.PDef);
				break;
			case DamageType.MAGIC:
				return Math.max(0, attack.getAttackRating() - target.MDef);
			}
			throw new Error("Unhandled damage type " + attack.type);
			return 0;
		}
		
		public static function doAttack(attack:AttackModel, target:UnitModel): Boolean {
			var dmg:int = calculateDamage(attack, target);
			return target.takeDamage(dmg);
		}
		
	}
}