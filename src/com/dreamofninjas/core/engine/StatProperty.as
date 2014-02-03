package com.dreamofninjas.core.engine {
	import com.dreamofninjas.core.interfaces.IHasEffects;
	import com.dreamofninjas.core.interfaces.IStatusEffect;
	
	public class StatProperty {
		public var base:int;
		public var type:StatType;
		private var owner:IHasEffects;

		public function currentValue():int {
			var val:int = this.base;
			for each(var effect:IStatusEffect in this.owner.getEffects()) {
				if (effect is IStatAffectingStatusEffect && (effect as IStatAffectingStatusEffect).getStat() == this.type) {
					 val += (effect as IStatAffectingStatusEffect).getAmount();
				}
			}
			return val;
		}

		function StatProperty(owner:IHasEffects, type:StatType, base:int = 0) {
			this.base = base
			this.type = type;
			this.owner = owner;
		}
	}
}
