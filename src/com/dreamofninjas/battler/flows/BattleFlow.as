package com.dreamofninjas.battler.flows
{
	import com.dreamofninjas.battler.models.BattleModel;
	import com.dreamofninjas.battler.views.BattleView;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import com.dreamofninjas.core.app.BaseFlow;

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
			if (evt.target is BattleSetupFlow) {
				setNextFlow(new UnitTurnFlow(battleModel, battleView));
			}
			if (evt.target is UnitTurnFlow) {
				if (!battleIsComplete(battleModel)) {
					setNextFlow(new UnitTurnFlow(battleModel, battleView));
				}
			}
		}
	}
}

/**
 internal class AfterUnitTurnFlow extends BaseFlow { }
 internal class BattleResultsFlow extends BaseFlow { }
 internal class CleanupBattleFlow extends BaseFlow { }
*/