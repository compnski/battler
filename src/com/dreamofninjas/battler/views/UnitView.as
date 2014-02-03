package com.dreamofninjas.battler.views
{
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.core.app.BaseView;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.text.TextField;

	public class UnitView extends BaseView {
		
		private var unitModel:UnitModel;
		private var text:TextField = new TextField(32, 32, "", "Impact", 30);
	//			this.bgColor = 0xc6d0af
		private static const COLORS:Object  = {
			"Player": 0xc6d0af,
			"Enemy": 0xeeeeee
		}
		public function UnitView(unitModel:UnitModel) {
			super(null);
			this.unitModel = unitModel;
			this.touchable = true;
			text.text = unitModel.faction.charAt(0).toUpperCase();
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
			
		private function addedToStage(evt:Event):void {
			this.x = unitModel.x;
			this.y = unitModel.y;
			unitModel.addEventListener(Event.CHANGE, modelUpdated);

			var q:Quad = new Quad(32, 32, COLORS[unitModel.faction]);
			filter = BlurFilter.createDropShadow();
			addChild(q);
			addChild(text);
		}
		
		private function modelUpdated(evt:Event):void {
			x = unitModel.x;
			y = unitModel.y;
		}
		
	}
}