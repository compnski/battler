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
		
		public function BattleFlow(battleModel:BattleModel, parentSprite:DisplayObjectContainer) {
			this.battleModel = battleModel;
			this.parentSprite = parentSprite;
		}
		
		public override function Execute():void {			
			var battleView:BattleView = new BattleView(battleModel);
			parentSprite.addChild(battleView);
			
			setNextFlow(new BattleSetupFlow(battleModel, battleView));
		}
		
		public override function Restored(evt:Event):void {
			if (evt.target is BattleSetupFlow) {
				setNextFlow(new StartBattleFlow(battleModel));
			}
			if (evt.target is UnitTurnFlow) {
				if (!battleIsComplete(battleModel)) {
					setNextFlow(new UnitTurnFlow(battleModel));
				}
			}
		}
	}
}

import com.dreamofninjas.battler.BaseFlow;
import com.dreamofninjas.battler.BattleModel;
import com.dreamofninjas.battler.BattleSetupView;
import com.dreamofninjas.battler.BattleView;

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
	}
}

internal class UnitTurnFlow extends BaseFlow {
	private var battleModel:BattleModel;
	public function UnitTurnFlow(battleModel:BattleModel) {
		this.battleModel = battleModel;
	}
	public override function Execute():void {
		trace("Unit turn!");
	}
}

internal class AfterUnitTurnFlow extends BaseFlow { }
internal class BattleResultsFlow extends BaseFlow { }
internal class CleanupBattleFlow extends BaseFlow { }

