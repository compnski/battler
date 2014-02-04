package com.dreamofninjas.battler.flows
{
	import com.dreamofninjas.battler.models.AiUnitModel;
	import com.dreamofninjas.battler.models.AttackModel;
	import com.dreamofninjas.battler.models.BattleModel;
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.battler.util.AttackUtils;
	import com.dreamofninjas.battler.util.BattlerPathUtils;
	import com.dreamofninjas.battler.views.BattleView;
	import com.dreamofninjas.core.app.BaseFlow;
	import com.dreamofninjas.core.engine.PathUtils;
	import com.dreamofninjas.core.ui.GPoint;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	public class AiUnitTurnFlow extends TurnFlow
	{
		
		private var battleModel:BattleModel;
		private var battleView:BattleView;
		private var unit:AiUnitModel;
		private var nextTurnAt:int;

		public function AiUnitTurnFlow(battleModel:BattleModel, battleView:BattleView, unit:AiUnitModel) {
			super(unit);
			this.battleModel = battleModel;
			this.battleView = battleView;
			this.unit = unit;
		}
						
		// TODO: return attacks, eventually find most damage across all possible attacks including moving
		private function tryAttack(target:UnitModel):Boolean {
			var viableAttacks:Array = new Array();
			for each(var attack:AttackModel in unit.attacks) {
				var attackArea:Object = AttackUtils.buildAttackArea(attack);
				if (AttackUtils.canAttack(attack, target, attackArea)) {
					viableAttacks.push({"attack": attack, "dmg":AttackUtils.calculateDamage(attack, target)}) 
				}
			}
			if (viableAttacks.length == 0) {
				return false;
			}
			viableAttacks.sortOn("dmg", Array.DESCENDING | Array.NUMERIC);
			AttackUtils.doAttack(viableAttacks[0].attack, target);
			this.addRecoveryTime(attack.recoveryTime);
			return true;
		}
		
		public override function Execute():void {
			trace("AI ATTACK")
			super.Execute();
			if (!unit.active) {
				trace("not active, return");
				return EndTurn();
			}

			var pathCostFunc:Function = function(loc:GPoint):int {
				var unitOnTile:UnitModel = battleModel.mapModel.getUnitAt(loc)
				if (unitOnTile != null) {
					return 999;
				}
				return BattlerPathUtils.getTileCost(unit, battleModel.mapModel.getTileAt(loc));
			}

			var nodeMap:Object = PathUtils.floodFill(unit.gpoint, pathCostFunc, unit.Move * 3);
			
			//TODO: Sort by actual travel cost
			//TODO: Need to set up factions / allies / etc.
			var targets:Vector.<UnitModel> = 
				battleModel.mapModel.units.filter(UnitModel.Filter(
					function(u:UnitModel):Boolean { return u.faction != unit.faction;}));
				
			targets.sort(UnitModel.DistanceSort(unit));
			var target:UnitModel = targets[0]
			if (target == null) {
				return EndTurn();
			}
			battleModel.targetUnit = target;
			
			if (tryAttack(target)) {
				return EndTurn(0, 0.7);
			}
			
			//find a place to stand.
			var targetPoint:GPoint;
			if (target.gpoint.up() in nodeMap) {
				targetPoint = target.gpoint.up();
			} else if(target.gpoint.down() in nodeMap) {
				targetPoint = target.gpoint.down();
			} else if(target.gpoint.left() in nodeMap) {
				targetPoint = target.gpoint.left();
			} else if(target.gpoint.right() in nodeMap) {
				targetPoint = target.gpoint.right();
			} else {
				return EndTurn();
			}
			var path:Array = PathUtils.getPath(nodeMap, unit.gpoint, targetPoint);
			if (path == null || path.length == 0) { 
				return EndTurn();
			}
			path = path.slice(0, unit.Move);
			this.onRestored(afterMove);
			setNextFlow(new MoveUnitFlow(battleView.mapView.getUnit(unit), path, Starling.juggler));
			//DFS to first target
			
			// single-turn plans
			// find targets
			// move
			
			// todo: multi-turn plan, stopping at best place in between moves
		}

		private function afterMove(evt:Event):void {
			if (evt.target is MoveUnitFlow) {
				// :[
				unit.r = (evt.target as MoveUnitFlow).dest.r;
				unit.c = (evt.target as MoveUnitFlow).dest.c;
			}

			var targets:Vector.<UnitModel> = 
				battleModel.mapModel.units.filter(UnitModel.Filter(
					function(u:UnitModel):Boolean { return u.faction == "Player";})).sort(
			
						UnitModel.DistanceSort(unit));
			var target:UnitModel = targets[0]
			if (targets == null) {
				return EndTurn();
			}
			tryAttack(target);
			return EndTurn(0, 0.7);
		}
	//todo find a home
	}
}