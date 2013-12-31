package com.dreamofninjas.battler.flows
{
	import starling.events.Event;
	import com.dreamofninjas.battler.models.BattleModel;
	import com.dreamofninjas.battler.views.BattleSetupView;
	import com.dreamofninjas.battler.views.BattleView;
	
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
			super.Execute();
			_battleSetupView = new BattleSetupView(battleModel);
			_battleSetupView.addEventListener(Event.COMPLETE, battleSetupComplete);
			battleView.addChild(_battleSetupView);
		}
		
		public override function Restored(evt:Event):void {
			super.Restored(evt);
		}
		
		private function battleSetupComplete(evt:Event):void {
			_battleSetupView.removeEventListeners();
			_battleSetupView.removeFromParent(true);
			battleModel.active = true;
			trace("Battle setup complete");
			Complete();
		}
	}
}