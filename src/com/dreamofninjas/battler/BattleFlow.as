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
import com.dreamofninjas.battler.GPoint;
import com.dreamofninjas.battler.Node;
import com.dreamofninjas.battler.PathUtils;
import com.dreamofninjas.battler.TileEvent;
import com.dreamofninjas.battler.UnitModel;
import com.dreamofninjas.battler.UnitView;

import starling.animation.Juggler;
import starling.animation.Tween;
import starling.core.Starling;
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
	private var unit:UnitModel;
	
	private var reachableArea:Object = {};
	
	public function UnitTurnFlow(battleModel:BattleModel, battleView:BattleView) {
		this.battleModel = battleModel;
		this.battleView = battleView;
	}
	
	public override function Execute():void {
		trace("Unit turn!");
		// Find current unit?
		unit = battleModel.getNextUnit();
		battleModel.currentUnit = unit;
		
		var pathCostFunction:Function = function(loc:GPoint):int {
			return 1;
		}
		reachableArea = PathUtils.floodFill(new GPoint(unit.r, unit.c), pathCostFunction, unit.move);
		
		var overlayTiles:Array = new Array();
		for each(var node:Node in reachableArea) {
			overlayTiles.push(node.gpoint);
		}
		
		battleView.drawOverlay(overlayTiles);
		battleView.addEventListener(TileEvent.CLICKED, tileClicked);
		// show move overlay
		// listen for move clicks		
	}
	
	private function tileClicked(evt:TileEvent):void {
		var loc:GPoint = evt.data as GPoint;
		trace(loc + " clicked");

		//trace( [evt.r, evt.c, evt.x, evt.r]);
		if (!(loc in reachableArea)) {
			return;
		}
		var path:Array = PathUtils.getPath(reachableArea, new GPoint(unit.r, unit.c), loc);
		trace(path);
		
		//battleModel.currentUnit.r = loc.r;
		//battleModel.currentUnit.c = loc.c;
		setNextFlow(new MovingUnitFlow(battleView.getUnit(unit), path, Starling.juggler));
	}
	
	public override function Restored(evt:Event):void {
		if (evt.target is MovingUnitFlow) {
			// :[
			unit.r = (evt.target as MovingUnitFlow).dest.r;
			unit.c = (evt.target as MovingUnitFlow).dest.c;
			
			// Show after move menu / start next flow.
		}
	}
}

internal class MovingUnitFlow extends BaseFlow {

	private var unit:UnitView;
	private var path:Array;
	private var juggler:Juggler;

	public var dest:GPoint;
	
	public function MovingUnitFlow(unit:UnitView, path:Array, juggler:Juggler) {
		this.unit = unit;
		this.path = path;
		this.juggler = juggler;
		this.dest = path[0];
	}
	
	public override function Execute():void {
		const MOVE_TIME:Number = 0.4;
		
		if (path.length == 0) {
			Complete();
			return;
		}
		var dest:GPoint = path.pop();
		var move:Tween = new Tween(unit, MOVE_TIME);
		move.onComplete = this.Execute;
		move.moveTo(dest.c * 32, dest.r * 32);
		juggler.add(move);
	}
		
}

internal class AfterUnitTurnFlow extends BaseFlow { }
internal class BattleResultsFlow extends BaseFlow { }
internal class CleanupBattleFlow extends BaseFlow { }
