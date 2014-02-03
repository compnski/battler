package com.dreamofninjas.battler.flows
{
	import com.dreamofninjas.core.engine.PathUtils;
	import com.dreamofninjas.battler.events.TileEvent;
	import com.dreamofninjas.battler.models.BattleModel;
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.battler.views.BattleView;
	import com.dreamofninjas.core.ui.RadialMenu;
	import com.dreamofninjas.core.ui.RadialMenuBuilder;
	import com.dreamofninjas.core.app.BaseFlow;
	import com.dreamofninjas.core.ui.GPoint;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class PlayerUnitTurnFlow extends BaseFlow {
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

		private var floodMap:Object = {};

		public function PlayerUnitTurnFlow(battleModel:BattleModel, battleView:BattleView, unit:UnitModel) {
			super();
			this.battleModel = battleModel;
			this.battleView = battleView;
			this.unit = unit;
		}

		public override function Execute():void {
			super.Execute();
			// Find current unit?
//			unit.getEffects().push(new StatAffectingStatusEffect(StatType.MOVE, 1));

			
			
			floodMap = PathUtils.floodFill(GPoint.g(unit.r, unit.c), PathUtils.getStdPathCostFunction(unit, battleModel.mapModel), unit.Move);

			currentUnitOverlay = battleView.drawOverlay(floodMap, 0x5566ee);
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

			var targetUnit:UnitModel = battleModel.mapModel.getUnitAt(dest);
			if (targetUnit) {
				battleModel.targetUnit = targetUnit;
				//TODO: Can walk up to but not touching the unit?
				return;
			}
			
			if (!(dest in floodMap) ||!floodMap[dest].reachable) { 
				return;
			}
			
			var path:Array = PathUtils.getPath(floodMap, start, dest);
			setNextFlow(new MoveUnitFlow(battleView.mapView.getUnit(unit), path, Starling.juggler));
		}

		protected override function release():void {
			super.release();
			battleView.removeEventListener(TileEvent.CLICKED, tileClicked);
			attackMenu.removeFromParent();
			if (currentUnitOverlay) {
				currentUnitOverlay.removeFromParent(true);
				currentUnitOverlay = null;
			}
			battleModel.targetUnit = null;
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
				if (evt.data) {
					Complete();
				}
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