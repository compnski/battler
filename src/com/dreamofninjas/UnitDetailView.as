package com.dreamofninjas
{
	import com.dreamofninjas.battler.UnitModel;
	import com.dreamofninjas.core.app.BaseView;
	
	import flash.geom.Rectangle;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	
	public class UnitDetailView extends BaseView {
		
		private var __item:UnitModel;
		
		protected function get _item():UnitModel {
			return __item;
		}
		
		protected function set _item(unitModel:UnitModel):void {
			if (__item == unitModel) {
				return;
			}
			if (__item) {
				__item.removeEventListener(Event.CHANGE, modelUpdated);
			}
			__item = unitModel;
			if (__item) {
				__item.addEventListener(Event.CHANGE, modelUpdated);
			}
		}
		
		public override function get z():int { 
			return 50;
		}
		
		public function UnitDetailView(unitModel:UnitModel, clipRect:Rectangle) {
			super(clipRect);
			_item = unitModel;
			var q:Quad = new Quad(250, 150, 0xc6d0af);
			addChild(q);
			var dropShadow:BlurFilter = BlurFilter.createDropShadow();
			filter = dropShadow;
		}		
		
		protected function modelUpdated(evt:Event):void {
			
		}
		
	}
}