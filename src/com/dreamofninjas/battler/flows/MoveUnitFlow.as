package com.dreamofninjas.battler.flows
{
	import starling.animation.Juggler;
	import starling.animation.Tween;
	import com.dreamofninjas.core.ui.GPoint;
	import com.dreamofninjas.battler.views.UnitView;
	import com.dreamofninjas.core.app.BaseFlow;
	
	internal class MoveUnitFlow extends BaseFlow {
		
		private var unit:UnitView;
		private var path:Array;
		private var juggler:Juggler;
		
		public var dest:GPoint;
		
		public function MoveUnitFlow(unit:UnitView, path:Array, juggler:Juggler) {
			super();
			this.unit = unit;
			this.path = path;
			this.juggler = juggler;
			this.dest = path[0];
		}
		
		public override function Execute():void {
			super.Execute();
			const MOVE_TIME:Number = 0.4;
			
			if (path.length == 0) {
				Complete();
				return;
			}
			var dest:GPoint = path.pop();
			var move:Tween = new Tween(unit, MOVE_TIME);
			move.onComplete = this.Execute;
			move.moveTo(dest.c * 32, dest.r * 32);
			juggler.add(move);
		}	
	}}