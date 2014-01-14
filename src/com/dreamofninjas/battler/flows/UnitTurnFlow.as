package com.dreamofninjas.battler.flows
{
	import com.dreamofninjas.battler.Node;
	import com.dreamofninjas.battler.PathUtils;
	import com.dreamofninjas.battler.StatAffectingStatusEffect;
	import com.dreamofninjas.battler.StatType;
	import com.dreamofninjas.battler.events.TileEvent;
	import com.dreamofninjas.battler.models.BattleModel;
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.battler.views.BattleView;
	import com.dreamofninjas.battler.views.RadialMenu;
	import com.dreamofninjas.battler.views.RadialMenuBuilder;
	import com.dreamofninjas.core.app.BaseFlow;
	import com.dreamofninjas.core.ui.GPoint;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

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

			// Find current unit?
			unit = battleModel.getNextUnit();
			battleModel.currentUnit = unit;
			trace("Unit turn for " + unit.type);
			trace("hp = " + unit.HP);
			unit.getEffects().push(new StatAffectingStatusEffect(StatType.MOVE, 1));
			// highlight current unit!

			battleView.mapView.centerOn(unit.x + 16, unit.y + 16);

			var pathCostFunction:Function = function(loc:GPoint):int {
				var unitOnTile:UnitModel = battleModel.mapModel.getUnitAt(loc)
				if (unitOnTile != null && unitOnTile.faction != unit.faction) {
					return 999;
				}
				return PathUtils.getTileCost(unit, battleModel.mapModel.getTileAt(loc));
			}
			reachableArea = PathUtils.floodFill(GPoint.g(unit.r, unit.c), pathCostFunction, unit.Move);

			var overlayTiles:Array = new Array();
			for each(var node:Node in reachableArea) {
				overlayTiles.push(node.gpoint);
			}

			currentUnitOverlay = battleView.drawOverlay(overlayTiles, 0x5566ee);
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
			var start:GPoint = GPoint.g(unit.r, unit.c);

			if (start.equals(dest)) {
				return;
			}

			if (!(dest in reachableArea)) {
				return;
			}

			var path:Array = PathUtils.getPath(reachableArea, start, dest);
			setNextFlow(new MoveUnitFlow(battleView.getUnit(unit), path, Starling.juggler));
		}

		protected override function release():void {
			super.release();
			battleView.removeEventListener(TileEvent.CLICKED, tileClicked);
			attackMenu.removeFromParent();
			if (currentUnitOverlay) {
				currentUnitOverlay.removeFromParent(true);
				currentUnitOverlay = null;
			}
		}

		public override function Suspended():void {
			super.Suspended();
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

			if (evt.target is UnitAttackFlow) {
				Complete();
			}
			// add listener [or ignore when not the active flow]?
		}

		private function doAttack():void {
			setNextFlow(new UnitAttackFlow(battleModel, battleModel.currentUnit, battleView));
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