package com.dreamofninjas.battler.views
{
	
	import flash.geom.Rectangle;
	
	import starling.events.Event;
	import com.dreamofninjas.battler.models.BattleModel;
	
	public class CurrentUnitDetailView extends UnitDetailView
	{
		public function CurrentUnitDetailView(battleModel:BattleModel, clipRect:Rectangle) {
			super(battleModel.currentUnit, clipRect);
		
			battleModel.addEventListener(Event.CHANGE, battleModelUpdated);
		}
	
		private function battleModelUpdated(evt:Event):void {
			_item = (evt.target as BattleModel).currentUnit;
		}
	}
}