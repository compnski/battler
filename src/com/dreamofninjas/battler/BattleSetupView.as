package com.dreamofninjas.battler
{
	import com.dreamofninjas.core.app.BaseView;
	
	import starling.events.Event;
	

	public class BattleSetupView extends BaseView
	{
		
		private var _setupMenu:RadialMenu = (new RadialMenu.Builder)()
			.withLeft("Inventory", selectInventory)
			.withUp("Select Units", selectUnits)
			.withRight("Position", selectPosition)
			.withDown("Start", complete)
			.build();
		
		public function BattleSetupView(battleModel:BattleModel) {
			super();
			addChild(_setupMenu);
		}
		
		private function selectInventory():void {
			trace('inv');
		}
		
		private function selectUnits():void {
			trace('select')
		}
		
		private function selectPosition():void {
			trace('pos');
		} 
		
		private function complete():void {
			_setupMenu.release();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
}