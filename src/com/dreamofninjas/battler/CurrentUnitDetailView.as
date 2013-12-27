package com.dreamofninjas.battler
{
	import com.dreamofninjas.UnitDetailView;
	
	import flash.geom.Rectangle;
	
	import starling.events.Event;
	
	public class CurrentUnitDetailView extends UnitDetailView
	{
		public function CurrentUnitDetailView(battleModel:BattleModel, clipRect:Rectangle) {
			super(null, clipRect);
		
			battleModel.addEventListener(Event.CHANGE, battleModelUpdated);
		}
	
		private function battleModelUpdated(evt:Event):void {
			_item = (evt.target as BattleModel).currentUnit;
		}
	}
}