package com.dreamofninjas.battler.flows
{
	import com.dreamofninjas.battler.PathUtils;
	import com.dreamofninjas.battler.events.TileEvent;
	import com.dreamofninjas.battler.models.AttackModel;
	import com.dreamofninjas.battler.models.BattleModel;
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.battler.views.AttackView;
	import com.dreamofninjas.battler.views.BattleView;
	import com.dreamofninjas.core.app.BaseFlow;
	import com.dreamofninjas.core.ui.GPoint;
	
	public class UnitAttackFlow extends BaseFlow
	{
		private var battleModel:BattleModel;
		private var battleView:BattleView;
		private var unit:UnitModel;
		private var attackOverlays:Object = new Object();
		private var attackAreas:Object = new Object();
		private var attackViews:Object = new Object();
		
		public function UnitAttackFlow(battleModel:BattleModel, unit:UnitModel, battleView:BattleView) {
			super();
			this.battleModel = battleModel;
			this.battleView = battleView;
			this.unit = unit;
		}
		
		public override function Execute():void {
			super.Execute();
			var pathCostFunction:Function = function(loc:GPoint):int {
				return 1;//PathUtils.getTileCost(unit, battleModel.mapModel.getTileAt(loc));
			}

			var i:int = 0;
			for each(var attack:AttackModel in unit.attacks) {
				var name:String = attack.name;
				attackAreas[name] = PathUtils.floodFill(new GPoint(unit.r, unit.c), pathCostFunction, attack.range);
				attackOverlays[name] = battleView.drawOverlay(attackAreas[attack.name], 0xee66ee);
				var view:AttackView = new AttackView(attack);
				battleView.addChild(view);
				view.y = view.parent.height - view.height - 10;
				view.x = i * (view.width + 10) + 10; 
				attackViews[name] = view;
				i++;
			}
			
			battleView.addEventListener(TileEvent.CLICKED, tileClicked);
		}	
		
		private function tileClicked(evt:TileEvent):void {
			if (!active) {
				return;
			}
			var dest:GPoint = evt.data as GPoint;
			trace(dest + " clicked");
			var start:GPoint = new GPoint(unit.r, unit.c);
			if (start.equals(dest)) {
				trace('bail');
				return;
			}

			var attacksInRange:Array = new Array();
			for (var name:String in attackAreas) {
				var area:Object = attackAreas[name];
				if (dest in area) {
					attacksInRange.push(name);
				}
			}
			if (attacksInRange.length == 0) {
				return;
			}

			var targetUnit:UnitModel = battleModel.mapModel.getUnitAt(dest);
			if (targetUnit != null) {
				battleModel.targetUnit = targetUnit;
			}
		}
	}
}