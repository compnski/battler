package com.dreamofninjas.battler.flows
{
	import com.dreamofninjas.battler.models.BattleModel;
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.battler.views.BattleSetupView;
	import com.dreamofninjas.battler.views.BattleView;
	import com.dreamofninjas.core.app.BaseFlow;
	
	import starling.events.Event;
	
	public class BattleSetupFlow extends BaseFlow {
		
		protected var _battleSetupView:BattleSetupView;
		private var battleModel:BattleModel;
		private var battleView:BattleView;
		
		public function BattleSetupFlow(battleModel:BattleModel, battleView:BattleView) {
			super();
			this.battleModel = battleModel;
			this.battleView = battleView;
		}
		
		public override function Execute():void {
			super.Execute()

			// add all unit turns
			for each (var unit:UnitModel in battleModel.units) {
				if (unit.active) {
					battleModel.queueNewTurnAction(unit, randint(1, 20));
				}
			}
			
			_battleSetupView = new BattleSetupView(battleModel);
			_battleSetupView.addEventListener(Event.COMPLETE, battleSetupComplete);
			battleView.addChild(_battleSetupView);
		}
		
		public override function Restored(evt:Event):void {
			super.Restored(evt);
		}
		
		protected override function release():void {
			super.release();
			_battleSetupView.removeFromParent();
			_battleSetupView.release();
		}
		
		private function battleSetupComplete(evt:Event):void {
			battleModel.active = true;
			trace("Battle setup complete");
			Complete();
		}
	}
}