package com.dreamofninjas.battler
{
	import com.dreamofninjas.core.app.BaseView;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class BattleView extends BaseView {
		private var battleModel:BattleModel;
		private var mapView:MapView;
		
		
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
			//mapView.addEventListener(TileEvent.CLICKED, tileClicked);
		}

		public function drawRangeOverlay(unit:UnitModel):void {
			mapView.drawRangeOverlay(unit);
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