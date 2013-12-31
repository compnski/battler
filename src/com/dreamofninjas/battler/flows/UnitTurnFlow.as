package com.dreamofninjas.battler.flows
{
	import starling.core.Starling;
	import starling.events.Event;
	import com.dreamofninjas.battler.models.BattleModel;
	import com.dreamofninjas.battler.views.BattleView;
	import com.dreamofninjas.battler.GPoint;
	import com.dreamofninjas.battler.Node;
	import com.dreamofninjas.battler.PathUtils;
	import com.dreamofninjas.battler.TileEvent;
	import com.dreamofninjas.battler.models.UnitModel;

	public class UnitTurnFlow extends BaseFlow {
		private var battleModel:BattleModel;
		private var battleView:BattleView;
		private var unit:UnitModel;
		
		private var reachableArea:Object = {};
		
		public function UnitTurnFlow(battleModel:BattleModel, battleView:BattleView) {
			super();
			this.battleModel = battleModel;
			this.battleView = battleView;
		}
		
		public override function Execute():void {
			super.Execute();
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
			if (!active) {
				return;
			}
			var dest:GPoint = evt.data as GPoint;
			trace(dest + " clicked");
			var start:GPoint = new GPoint(unit.r, unit.c);
			
			if (!(dest in reachableArea) || (start == dest)) {
				return;
			}
			
			if (start == dest) {
				return;
			}
			var path:Array = PathUtils.getPath(reachableArea, start, dest);
			trace(path);
			
			//battleModel.currentUnit.r = loc.r;
			//battleModel.currentUnit.c = loc.c;
			setNextFlow(new MoveUnitFlow(battleView.getUnit(unit), path, Starling.juggler));
		}
		
		public override function Restored(evt:Event):void {
			super.Restored(evt);
			if (evt.target is MoveUnitFlow) {
				// :[
				unit.r = (evt.target as MoveUnitFlow).dest.r;
				unit.c = (evt.target as MoveUnitFlow).dest.c;
				// Show after move menu / start next flow.
			}
			// add listener [or ignore when not the active flow]?
		}
	}
}