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
			return Math.max(0, attack.getAttackRating() - target.PDef);
		}
		
		public static function doAttack(attack:AttackModel, target:UnitModel): int {
			return 0;
		}
		
	}
}