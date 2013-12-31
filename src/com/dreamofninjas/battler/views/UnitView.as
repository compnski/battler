package com.dreamofninjas.battler.views
{
	import com.dreamofninjas.core.app.BaseView;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import com.dreamofninjas.battler.models.UnitModel;

	public class UnitView extends BaseView {
		
		private var unitModel:UnitModel;
		private static const COLORS:Object  = {
			"Player": 0x44EE44,
			"Enemy": 0xEE4444
		}
		public function UnitView(unitModel:UnitModel) {
			super(null);
			this.unitModel = unitModel;
			this.touchable = true;
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
			
		private function addedToStage(evt:Event):void {
			this.x = unitModel.x;
			this.y = unitModel.y;
			unitModel.addEventListener(Event.CHANGE, modelUpdated);

			var q:Quad = new Quad(32, 32, COLORS[unitModel.faction]);
			filter = BlurFilter.createDropShadow();
			addChild(q);
		}
		
		private function modelUpdated(evt:Event):void {
			x = unitModel.x;
			y = unitModel.y;
		}
		
	}
}