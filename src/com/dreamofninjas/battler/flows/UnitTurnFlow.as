package com.dreamofninjas.battler.flows
{
	import com.dreamofninjas.core.ui.GPoint;
	import com.dreamofninjas.battler.Node;
	import com.dreamofninjas.battler.PathUtils;
	import com.dreamofninjas.battler.events.TileEvent;
	import com.dreamofninjas.battler.models.BattleModel;
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.battler.views.BattleView;
	import com.dreamofninjas.battler.views.RadialMenu;
	import com.dreamofninjas.battler.views.RadialMenuBuilder;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import com.dreamofninjas.core.app.BaseFlow;

	public class UnitTurnFlow extends BaseFlow {
		private var battleModel:BattleModel;
		private var battleView:BattleView;
		private var unit:UnitModel;
		private var currentUnitOverlay:DisplayObject;
		private const attackMenu:RadialMenu = new RadialMenuBuilder()
					.withUp('Attack', doAttack)
					.withDown('Wait', doWait)
					.withLeft('Skill', doSkill)
					.withRight('Item', doItem)
					.build();
		
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

			battleView.mapView.centerOn(unit.x + 16, unit.y + 16);
			
			var pathCostFunction:Function = function(loc:GPoint):int {
				return PathUtils.getTileCost(unit, battleModel.mapModel.getTileAt(loc));
			}
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
		
		private function release():void {
			attackMenu.removeFromParent();
			if (currentUnitOverlay) {
				currentUnitOverlay.removeEventListeners();
				currentUnitOverlay.removeFromParent();
				currentUnitOverlay = null;
			}
		}
		
		public function Complete():void {
			release();
			super.Complete();
		}
		
		public override function Suspended():void {
			currentUnitOverlay.visible = false;
			attackMenu.visible = false;
		}
		
		public override function Restored(evt:Event):void {
			super.Restored(evt);
			currentUnitOverlay.visible = true;
			attackMenu.visible = true;
			
			if (evt.target is MoveUnitFlow) {
				// :[
				unit.r = (evt.target as MoveUnitFlow).dest.r;
				unit.c = (evt.target as MoveUnitFlow).dest.c;
			}
			// add listener [or ignore when not the active flow]?
		}
		
		private function doAttack():void {
			
		}
		private function doWait():void {
			Complete();
		}
		private function doSkill():void {
			
		}
		private function doItem():void {
			
		}
		
		
	}
}