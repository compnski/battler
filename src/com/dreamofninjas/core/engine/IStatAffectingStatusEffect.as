
package com.dreamofninjas.core.engine {
	import com.dreamofninjas.core.interfaces.IStatusEffect;

	public interface IStatAffectingStatusEffect extends IStatusEffect {
		function getStat():StatType;
		function getAmount():int;
	}
}
