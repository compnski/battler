package com.dreamofninjas.battler.flows
{
	import com.dreamofninjas.battler.events.UnitEvent;
	import com.dreamofninjas.battler.models.Action;
	import com.dreamofninjas.battler.models.AiUnitModel;
	import com.dreamofninjas.battler.models.BattleModel;
	import com.dreamofninjas.battler.models.LevelModel;
	import com.dreamofninjas.battler.models.TurnAction;
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.battler.views.BattleView;
	import com.dreamofninjas.battler.views.MapView;
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
		private var levelModel:LevelModel;
		private var battleView:BattleView;

		public function BattleFlow(levelModel:LevelModel, battleModel:BattleModel, parentSprite:DisplayObjectContainer, mapView:MapView) {
			super();
			this.levelModel = levelModel;
			this.battleModel = battleModel;
			this.parentSprite = parentSprite;
			battleModel.mapModel.addEventListener(UnitEvent.ACTIVATED, aiUnitActivated);
			this.battleView = new BattleView(battleModel, mapView);

		}

		private function aiUnitActivated(evt:Event):void {
			if(evt.data as Boolean) {
				this.battleModel.queueNewTurnAction(evt.target as UnitModel, randint(1, 20));
			}
		}
		
		public override function Execute():void {
			super.Execute();
			parentSprite.addChild(battleView);

			setNextFlow(new BattleSetupFlow(battleModel, battleView));
		}

		public override function Restored(evt:Event):void {
			super.Restored(evt);
			//cleanup?
			if (evt.target is TurnFlow) {
				var unit:UnitModel = evt.data.unit;
				var recoveryTime:int = evt.data.recoveryTime;
				if (recoveryTime == 0) {
					throw new Error("Unit can't move twice in the same instant. Must be at least 1 delay");
				}
				this.levelModel.afterUnitTurn(unit);
				postTurnCleanup();
				battleModel.queueNewTurnAction(unit, recoveryTime);
			}
			executeNextAction();
		}

		private function executeNextAction():void {
			if (!battleModel.active) {
				return Complete();
			}

			trace(battleModel.actionQueue.queue);
			var action:Action = battleModel.actionQueue.popNextAction();
			trace(battleModel.actionQueue.queue);
			if (action is TurnAction) {
				var turn:TurnAction = action as TurnAction;
				if (!turn.unit.active) {
					return executeNextAction(); // try again
				}
				return startNextTurn(turn.unit);
			} else {
				throw new Error("Unexpected action: " + action);
			}
		}
		
		private function startNextTurn(unit:UnitModel):void {
			battleModel.currentUnit = unit;
			battleView.mapView.centerOn(battleModel.currentUnit);
			
			if (battleModel.currentUnit is AiUnitModel) {
				setNextFlow(new AiUnitTurnFlow(battleModel, battleView, battleModel.currentUnit as AiUnitModel));
			} else {
				setNextFlow(new PlayerUnitTurnFlow(battleModel, battleView, battleModel.currentUnit));
			}
		}
				
		protected override function release():void {
			super.release();
			battleModel.currentUnit = null;
			battleModel.targetUnit = null;
			battleView.release();
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
			trace("active: " + battleModel.active);
			battleModel.targetUnit = null;
			
			//battleIsComplete(battleModel)
		}
	}
}

/**
 internal class AfterUnitTurnFlow extends BaseFlow { }
 internal class BattleResultsFlow extends BaseFlow { }
 internal class CleanupBattleFlow extends BaseFlow { }
*/