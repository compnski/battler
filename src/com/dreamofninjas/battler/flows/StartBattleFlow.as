package com.dreamofninjas.battler.flows
{
	import com.dreamofninjas.battler.models.BattleModel;
	import com.dreamofninjas.core.app.BaseFlow;

	internal class StartBattleFlow extends BaseFlow {
		private var battleModel:BattleModel;
		public function StartBattleFlow(battleModel:BattleModel) {
			super();
			this.battleModel = battleModel;
		}
		public override function Execute():void {
			super.Execute();
			trace("Start Battle!");
			Complete();
		}
	}
}