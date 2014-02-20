package com.dreamofninjas.battler.flows
{
	import com.dreamofninjas.battler.views.UnitView;
	import com.dreamofninjas.core.app.BaseFlow;
	import com.dreamofninjas.core.ui.GPoint;
	
	import starling.animation.Juggler;
	import starling.animation.Tween;
	
	internal class MoveUnitFlow extends BaseFlow {
		
		private var unit:UnitView;
		private var path:Array;
		private var juggler:Juggler;
		private var speed_tps:int;
		
		public var dest:GPoint;
		
		public function MoveUnitFlow(unit:UnitView, speed_tps:int, path:Array, juggler:Juggler) {
			super();
			this.unit = unit;
			this.path = path;
			this.juggler = juggler;
			this.dest = path[0];
			this.speed_tps = speed_tps;
		}
		
		public override function Execute():void {
			super.Execute();
			const MOVE_TIME:Number = 0.15;
			
			if (path.length == 0) {
				Complete();
				return;
			}
			var movetime:Number = 1 / speed_tps;
			var dest:GPoint = path.pop();
			var move:Tween = new Tween(unit, movetime);
			move.onComplete = this.Execute;
			move.moveTo(dest.c * 32, dest.r * 32);
			juggler.add(move);
		}	
	}}