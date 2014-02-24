package com.dreamofninjas.battler.views
{
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.core.app.BaseView;
	import com.dreamofninjas.core.ui.ProgressBar;
	
	import flash.geom.Rectangle;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.utils.Color;
	
	public class UnitDetailView extends BaseView {
		
		private var __item:UnitModel;
			
		protected function get _item():UnitModel {
			return __item;
		}
		
		private var _nameLabel:TextField = new TextField(80, 30, "", "Arial", 13);
		private var _factionLabel:TextField = new TextField(70, 30, "", "Arial", 13);
		private var _typeLabel:TextField = new TextField(100, 30, "", "Arial", 13);
		private var _mpBar:ProgressBar;
		private var _hpBar:ProgressBar;
		protected var bgColor:uint = 0xc6d0af;
		
		protected function set _item(unitModel:UnitModel):void {
			if (__item === unitModel) {
				return;
			}
			if (__item) {
				__item.removeEventListener(Event.CHANGE, modelUpdated);
			}
			__item = unitModel;
			if (__item) {
				__item.addEventListener(Event.CHANGE, modelUpdated);
			}
			modelUpdated(null);
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
			var q:Quad = new Quad(250, 150, this.bgColor);
			addChild(q);
			addChild(_nameLabel);
			
			_hpBar = new ProgressBar(new Rectangle(0, 0, 200, 30), 0xF83538, 1, 1);
			_hpBar.x = 5;
			_hpBar.y = 30
			
			_mpBar = new ProgressBar(new Rectangle(0, 0, 200, 30), 0x3E4F98, 1, 1);
			_mpBar.x = 5;
			_mpBar.y = 70;
							
			addChild(_hpBar);
			addChild(_mpBar);
			
			addChild(_factionLabel);
			addChild(_typeLabel);
			
			var dropShadow:BlurFilter = BlurFilter.createDropShadow();
			filter = dropShadow;
			modelUpdated(null);
		}
		
		protected function modelUpdated(evt:Event):void {
			if (_item) {
				show();
			} else {
				hide();
				return;
			}
			//_nameLabel.text = _item.name;
			_factionLabel.text = _item.faction;
			_typeLabel.text = _item.Job();

			_hpBar.reset(_item.curHP, _item.MaxHP);
			_mpBar.reset(_item.curMP, _item.MaxMP);	
			/*
			_hpBar.maxValue = _item.MaxHP;
			_hpBar.value = _item.HP;

			_mpBar.maxValue = _item.MaxMP;
			_mpBar.value = _item.MP;
				*/		
			relayout()
		}
		
		private function relayout():void {
			_factionLabel.x = 10;
			_typeLabel.x = _factionLabel.width + _factionLabel.x + 20;
		}
		
	}
}