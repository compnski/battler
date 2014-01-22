package com.dreamofninjas.battler.views
{
	import com.dreamofninjas.battler.models.BattleModel;
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.core.app.BaseView;
	import com.dreamofninjas.core.ui.DisplayFactory;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class BattleView extends BaseView {
		private var battleModel:BattleModel;
		public var mapView:MapView;
		
		
		protected var _uiLayer:Sprite = DisplayFactory.getSprite();
		protected var _mapLayer:Sprite = DisplayFactory.getSprite();
		
		private var _targetUnitView:UnitDetailView;
		private var _selectedUnitView:UnitDetailView;
		
		private var unitModelToView:Dictionary = new Dictionary(true);

		
		public function BattleView(battleModel:BattleModel)
		{
			super(new Rectangle(0, 0, 1280, 720));
			this.battleModel = battleModel;
			mapView = new MapView(new Rectangle(0, 0, 1280, 720), battleModel.mapModel);
			this.touchable = true;
			_mapLayer.touchable = true;

			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function initUi():void {
			_targetUnitView = new TargetUnitDetailView(battleModel, null);
			_targetUnitView.x = 892;
			_targetUnitView.y = 64;
			addChild(_targetUnitView);	
			
			_selectedUnitView = new CurrentUnitDetailView(battleModel, null);
			_selectedUnitView.x = 96;
			_selectedUnitView.y = 64;
			addChild(_selectedUnitView);
		}

		public function getUnit(unit:UnitModel):UnitView {
			return unitModelToView[unit];
		}
		 
		public function highlightUnit(unit:UnitModel, color:uint):DisplayObject {
			var q:Quad = new Quad(32, 32);
			q.color = color;
			q.alpha = 0.6;
			getUnit(unit).addChild(q);
			return q;
		}
			
		public function drawOverlay(tiles:Object, color:uint):DisplayObject {
			return mapView.drawOverlay(tiles, color);
		}
		
		private function addedToStage(evt:Event):void {
			addChild(mapView);
			initUi();
			for each(var unit:UnitModel in battleModel.units) {
				var unitView:UnitView = new UnitView(unit);
				unitModelToView[unit] = unitView;
				mapView.addUnit(unitView);
			}
		}		
	}
}