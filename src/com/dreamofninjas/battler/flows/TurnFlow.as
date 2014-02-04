package com.dreamofninjas.battler.flows
{
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.core.app.BaseFlow;
	
	public class TurnFlow extends BaseFlow
	{
		private var unit:UnitModel;
		private var recoveryTime:int = 0;
		
		public function TurnFlow(unit:UnitModel)
		{
			super();
			this.unit = unit;
		}
				
		protected function addRecoveryTime(amt:int):int {
			this.recoveryTime += amt;
			return this.recoveryTime
		}
		
		protected function EndTurn(recoveryTime:int=0, animationDelay:Number=0):void {
			addRecoveryTime(recoveryTime);
			addRecoveryTime(unit.recoveryTime); // Base unit value
			var data:Object = {"recoveryTime":this.recoveryTime, "unit":this.unit};
			if (animationDelay) {
				DelayedComplete(animationDelay, data);
			} else {
				Complete(data)
			}
		}
	}
}