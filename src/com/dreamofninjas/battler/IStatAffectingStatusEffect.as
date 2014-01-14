
package com.dreamofninjas.battler {
	public interface IStatAffectingStatusEffect extends IStatusEffect {
		function getStat():StatType;
		function getAmount():int;
	}
}
