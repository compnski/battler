package com.dreamofninjas.battler
{
	
	import flash.geom.Rectangle;
	
	import starling.events.Event;
	
	public class TargetUnitDetailView extends UnitDetailView
	{
		public function TargetUnitDetailView(battleModel:BattleModel, clipRect:Rectangle)
		{
			super(battleModel.targetUnit, clipRect);
			battleModel.addEventListener(Event.CHANGE, battleModelUpdated);
		}
		
		private function battleModelUpdated(evt:Event):void {
			_item = (evt.target as BattleModel).targetUnit;
		}
		
	}
}