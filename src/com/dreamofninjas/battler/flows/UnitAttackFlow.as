package com.dreamofninjas.battler.flows
{
	import com.dreamofninjas.battler.AttackUtils;
	import com.dreamofninjas.battler.PathUtils;
	import com.dreamofninjas.battler.events.TileEvent;
	import com.dreamofninjas.battler.models.AttackModel;
	import com.dreamofninjas.battler.models.BattleModel;
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.battler.views.AttackView;
	import com.dreamofninjas.battler.views.BattleView;
	import com.dreamofninjas.core.app.BaseFlow;
	import com.dreamofninjas.core.ui.GPoint;
	
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
		
	public class UnitAttackFlow extends BaseFlow
	{
		private var battleModel:BattleModel;
		private var battleView:BattleView;
		private var unit:UnitModel;
		private var attackOverlays:Dictionary = new Dictionary();
		private var attackAreas:Dictionary = new Dictionary();
		private var attackViews:Dictionary = new Dictionary();
		
		public function UnitAttackFlow(battleModel:BattleModel, unit:UnitModel, battleView:BattleView) {
			super();
			this.battleModel = battleModel;
			this.battleView = battleView;
			this.unit = unit;
		}
		
		protected override function release():void {
			super.release();
			for each(var view:AttackView in attackViews) {
				view.release();
			}
			for each(var overlay:DisplayObject in attackOverlays) {
				overlay.removeFromParent(true);
			}
			
			battleView.removeEventListener(TileEvent.CLICKED, tileClicked);
			battleView.removeEventListener(Event.TRIGGERED, attackClicked);
		}
		
		public override function Execute():void {
			super.Execute();
			var pathCostFunction:Function = function(loc:GPoint):int {
				return 1;//PathUtils.getTileCost(unit, battleModel.mapModel.getTileAt(loc));
			}

			//highlight attackable units!
				
			var i:int = 0;
			for each(var attack:AttackModel in unit.attacks) {
				var name:String = attack.name;
				attackAreas[attack] = PathUtils.floodFill(GPoint.g(unit.r, unit.c), pathCostFunction, attack.range);
				attackOverlays[attack] = battleView.drawOverlay(attackAreas[attack], 0xee66ee);
				var view:AttackView = new AttackView(attack);
				battleView.addChild(view);
				view.y = view.parent.height - view.height - 10;
				view.x = i * (view.width + 10) + 10; 
				attackViews[attack] = view;
				i++;
			}
			
			battleView.addEventListener(TileEvent.CLICKED, tileClicked);
			battleView.addEventListener(Event.TRIGGERED, attackClicked);
			refreshWeaponUi(getAttacksTargettingUnit(battleModel.targetUnit));
		}	
		
		private function attackClicked(evt:Event):void {
			if (!(evt.target is AttackView)) {
				return;
			}
			if (!active || battleModel.targetUnit == null) {
				return;
			}

			var attack:AttackModel = evt.data as AttackModel;
			AttackUtils.doAttack(attack, battleModel.targetUnit);
			Complete();
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
			if (targetUnit == null) {
				return;
			}
			battleModel.targetUnit = targetUnit;
			refreshWeaponUi(getAttacksTargettingUnit(targetUnit));
		}
			
		private function getAttacksTargettingUnit(targetUnit:UnitModel):Dictionary {
			var attacksInRange:Dictionary = new Dictionary();
			if (targetUnit == null) {
				return attacksInRange;
			}
			var attackFound:int = 0;
			for (var attack:AttackModel in attackAreas) {
				var area:Object = attackAreas[attack];
				if (targetUnit.gpoint in area && area[targetUnit.gpoint].reachable && AttackUtils.canAttack(attack, targetUnit)) {
					attacksInRange[attack] = attack;
					attackFound++;
				}
			}
			return attacksInRange;
		}
		
		private function refreshWeaponUi(attacksInRange:Dictionary):void {
			for (var model:AttackModel in attackViews) {
				var view:AttackView = this.attackViews[model];				
				if (model in attacksInRange) {
					view.enabled = true;
				} else {
					view.enabled = false;
				}
			}
		}
	}
}