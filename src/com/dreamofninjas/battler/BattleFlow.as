package com.dreamofninjas.battler
{
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
			this.battleModel = battleModel;
			this.parentSprite = parentSprite;
		}

		public override function Execute():void {
			battleView = new BattleView(battleModel);
			parentSprite.addChild(battleView);

			setNextFlow(new BattleSetupFlow(battleModel, battleView));
		}

		public override function Restored(evt:Event):void {
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

import com.dreamofninjas.battler.BaseFlow;
import com.dreamofninjas.battler.BattleModel;
import com.dreamofninjas.battler.BattleSetupView;
import com.dreamofninjas.battler.BattleView;
import com.dreamofninjas.battler.TileEvent;

import starling.events.Event;

internal class BattleSetupFlow extends BaseFlow {

	protected var _battleSetupView:BattleSetupView;
	private var battleModel:BattleModel;
	private var battleView:BattleView;

	public function BattleSetupFlow(battleModel:BattleModel, battleView:BattleView) {
		this.battleModel = battleModel;
		this.battleView = battleView;
	}

	public override function Execute():void {
		_battleSetupView = new BattleSetupView(battleModel);
		_battleSetupView.addEventListener(Event.COMPLETE, battleSetupComplete);
		battleView.addChild(_battleSetupView);
	}

	public override function Restored(evt:Event):void {

	}

	private function battleSetupComplete(evt:Event):void {
		_battleSetupView.removeEventListeners();
		_battleSetupView.removeFromParent(true);
		battleModel.active = true;
		trace("Battle setup complete");
		Complete();
	}
}

internal class StartBattleFlow extends BaseFlow {
	private var battleModel:BattleModel;
	public function StartBattleFlow(battleModel:BattleModel) {
		this.battleModel = battleModel;
	}
	public override function Execute():void {
		trace("Start Battle!");
		Complete();
	}
}

internal class UnitTurnFlow extends BaseFlow {
	private var battleModel:BattleModel;
	private var battleView:BattleView;
	
	public function UnitTurnFlow(battleModel:BattleModel, battleView:BattleView) {
		this.battleModel = battleModel;
		this.battleView = battleView;
	}
	
	public override function Execute():void {
		trace("Unit turn!");
		// Find current unit?
		battleModel.currentUnit = battleModel.getNextUnit();
		battleView.drawRangeOverlay(battleModel.currentUnit);
		battleView.addEventListener(TileEvent.CLICKED, tileClicked);
		// show move overlay
		// listen for move clicks		
	}
	
	private function tileClicked(evt:TileEvent):void {
		trace( [evt.r, evt.c, evt.x, evt.r]);
		
		battleModel.currentUnit.r = evt.r;
		battleModel.currentUnit.c = evt.c;
	}
	
}

internal class AfterUnitTurnFlow extends BaseFlow { }
internal class BattleResultsFlow extends BaseFlow { }
internal class CleanupBattleFlow extends BaseFlow { }
