package com.dreamofninjas.battler.util
{
	import com.dreamofninjas.battler.models.AttackModel;
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.core.ui.GPoint;
	
	import flash.utils.Dictionary;
	import com.dreamofninjas.battler.models.DamageType;
	import com.dreamofninjas.core.engine.PathUtils;

	public class AttackUtils
	{
		public function AttackUtils() {
		}
		
		// If attack area is passed in, also does distance checks
		public static function canAttack(attack:AttackModel, target:UnitModel, attackArea:Object = null):Boolean {
				if (attackArea != null && !(target.gpoint in attackArea)) {
					return false;
				}
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
		
		public static function buildAttackArea(attack:AttackModel):Object {
			var unit:UnitModel = attack.attacker;
			return PathUtils.floodFill(GPoint.g(unit.r, unit.c), pathCostFunction, attack.range);
		}
		
		public static function getAttacksTargettingUnit(attackAreas:Dictionary, targetUnit:UnitModel):Dictionary {
			var attacksInRange:Dictionary = new Dictionary();
			if (targetUnit == null) {
				return attacksInRange;
			}
			var attackFound:int = 0;
			for (var attack:AttackModel in attackAreas) {
				var area:Object = attackAreas[attack];
				if (targetUnit.gpoint in area && area[targetUnit.gpoint].reachable && AttackUtils.canAttack(attack, targetUnit)) {
					attacksInRange[attack] = attack;
					attackFound++;
				}
			}
			return attacksInRange;
		}

		private static function pathCostFunction(loc:GPoint):int {
			return 1;
		}
		
	}
}