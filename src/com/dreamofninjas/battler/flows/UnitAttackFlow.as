package com.dreamofninjas.battler.flows
{
	import com.dreamofninjas.battler.util.AttackUtils;
	import com.dreamofninjas.core.engine.PathUtils;
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
	import starling.events.KeyboardEvent;
		
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
			battleView.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
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
				attackAreas[attack] = AttackUtils.buildAttackArea(attack);
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
			battleView.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			refreshWeaponUi(AttackUtils.getAttacksTargettingUnit(attackAreas, battleModel.targetUnit));
		}	
		
		private function keyUp(evt:KeyboardEvent):void {
			if (!active) {
				return;
			}
			
			if (evt.keyCode == 27) { //esc 
				Complete();
			}
		}
		
		private function setFlowVisibility(vis:Boolean):void {	
			
			for each(var view:AttackView in attackViews) {
				view.visible = vis;
			}
			for each(var overlay:DisplayObject in attackOverlays) {
				overlay.visible = vis;
			}
		}
		
		public override function Suspended():void {
			super.Suspended();
			this.setFlowVisibility(false);
		}

		public override function Restored(evt:Event):void {
			super.Restored(evt);
			this.setFlowVisibility(true);
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
			setFlowVisibility(false);
			DelayedComplete(0.7, attack);
		}
		
		private function tileClicked(evt:TileEvent):void {
			//refactor this to work on battle model updated?
			
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
			refreshWeaponUi(AttackUtils.getAttacksTargettingUnit(attackAreas, targetUnit));
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