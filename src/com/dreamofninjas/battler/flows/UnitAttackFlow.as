package com.dreamofninjas.battler.flows
{
	import com.dreamofninjas.battler.Node;
	import com.dreamofninjas.battler.PathUtils;
	import com.dreamofninjas.battler.events.TileEvent;
	import com.dreamofninjas.battler.models.BattleModel;
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.battler.views.BattleView;
	import com.dreamofninjas.core.app.BaseFlow;
	import com.dreamofninjas.core.ui.GPoint;
	
	public class UnitAttackFlow extends BaseFlow
	{
		private var battleModel:BattleModel;
		private var battleView:BattleView;
		private var unit:UnitModel;

		public function UnitAttackFlow(battleModel:BattleModel, unit:UnitModel, battleView:BattleView) {
			super();
			this.battleModel = battleModel;
			this.battleView = battleView;
			this.unit = unit;
		}
		
		public override function Execute():void {
			var pathCostFunction:Function = function(loc:GPoint):int {
				return PathUtils.getTileCost(unit, battleModel.mapModel.getTileAt(loc));
			}
			/*
			reachableArea = PathUtils.floodFill(new GPoint(unit.r, unit.c), pathCostFunction, unit.move);
			
			var overlayTiles:Array = new Array();
			for each(var node:Node in reachableArea) {
				overlayTiles.push(node.gpoint);
			}
			
			currentUnitOverlay = battleView.drawOverlay(overlayTiles);
			battleView.addEventListener(TileEvent.CLICKED, tileClicked);
			battleView.addChild(attackMenu);
			// show move overlay
			// listen for move clicks		
		*/	
		}	
	}
}