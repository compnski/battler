package com.dreamofninjas.battler.views
{
	import com.dreamofninjas.core.app.BaseView;
	
	import flash.geom.Rectangle;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import com.dreamofninjas.battler.models.UnitModel;
	
	public class UnitDetailView extends BaseView {
		
		private var __item:UnitModel;
			
		protected function get _item():UnitModel {
			return __item;
		}
		
		private var _nameLabel:TextField = new TextField(80, 30, "");
		private var _factionLabel:TextField = new TextField(70, 30, "");
		private var _typeLabel:TextField = new TextField(100, 30, "");
		
		protected function set _item(unitModel:UnitModel):void {
			if (__item === unitModel) {
				trace('aredy set' );
				return;
			}
			if (__item) {
				__item.removeEventListener(Event.CHANGE, modelUpdated);
			}
			__item = unitModel;
			if (__item) {
				__item.addEventListener(Event.CHANGE, modelUpdated);
				modelUpdated(null);
			}
		}
		
		public override function get z():int { 
			return 50;
		}
		
		public function UnitDetailView(unitModel:UnitModel, clipRect:Rectangle) {
			super(clipRect);
			_item = unitModel;

			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}		
		
		public function addedToStage(evt:Event):void {
			var q:Quad = new Quad(250, 150, 0xc6d0af);
			addChild(q);
			addChild(_nameLabel);
			
			
			addChild(_factionLabel);
			addChild(_typeLabel);
			
			var dropShadow:BlurFilter = BlurFilter.createDropShadow();
			filter = dropShadow;
			if (_item != null) {
				modelUpdated(null);
			}
		}
		
		protected function modelUpdated(evt:Event):void {
			//_nameLabel.text = _item.name;
			_factionLabel.text = _item.faction;
			_typeLabel.text = _item.type;
			
			relayout()
		}
		
		private function relayout():void {
			_factionLabel.x = 10;
			_typeLabel.x = _factionLabel.width + _factionLabel.x + 20;
		}
		
	}
}