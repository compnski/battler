package com.dreamofninjas.battler.flows
{
	import com.dreamofninjas.battler.models.BattleModel;
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.battler.views.BattleView;
	import com.dreamofninjas.core.app.BaseFlow;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	public class BattleFlow extends BaseFlow
	{
		private function battleIsComplete(battleModel:BattleModel):Boolean {
			return !battleModel.active;
		}

		private var parentSprite:DisplayObjectContainer;
		private var battleModel:BattleModel;
		private var battleView:BattleView;

		public function BattleFlow(battleModel:BattleModel, parentSprite:DisplayObjectContainer) {
			super();
			this.battleModel = battleModel;
			this.parentSprite = parentSprite;
		}

		public override function Execute():void {
			super.Execute();
			battleView = new BattleView(battleModel);
			parentSprite.addChild(battleView);

			setNextFlow(new BattleSetupFlow(battleModel, battleView));
		}

		public override function Restored(evt:Event):void {
			super.Restored(evt);
			//cleanup?
			
			if (evt.target is BattleSetupFlow) {
				setNextFlow(new UnitTurnFlow(battleModel, battleView));
			}
			if (evt.target is UnitTurnFlow) {
				postTurnCleanup();
				
				if (battleIsComplete(battleModel)) {
					trace("BATTLE HAS ENDED");
					//Complete();
				} else {
					setNextFlow(new UnitTurnFlow(battleModel, battleView));
				}
			}
		}
		
		protected override function release():void {
			battleModel.currentUnit = null;
			battleModel.targetUnit = null;
		}
		
		private function postTurnCleanup():void {
			// Clean up views
			//TODO: clean this up
			var anyPlayerUnits:Boolean = false;
			var anyEnemyUnits:Boolean = false;
			
			for each (var unit:UnitModel in battleModel.units) {
				if (unit.faction == "Player") {
					anyPlayerUnits = true;
				}
				if (unit.faction == "Enemy") {
					anyEnemyUnits = true;
				}
			}
			battleModel.active = anyPlayerUnits && anyEnemyUnits;
		}
	}
}

/**
 internal class AfterUnitTurnFlow extends BaseFlow { }
 internal class BattleResultsFlow extends BaseFlow { }
 internal class CleanupBattleFlow extends BaseFlow { }
*/