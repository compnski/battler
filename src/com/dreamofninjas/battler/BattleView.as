package com.dreamofninjas.battler
{
	import com.dreamofninjas.core.app.BaseView;
	
	import flash.geom.Rectangle;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class BattleView extends BaseView {
		private var battleModel:BattleModel;
		private var mapView:MapView;
		
		
		protected var _uiLayer:Sprite = new Sprite();
		protected var _mapLayer:Sprite = new Sprite();
		
		private var _targetUnitView:UnitDetailView;
		private var _selectedUnitView:UnitDetailView;

		
		public function BattleView(battleModel:BattleModel)
		{
			super(new Rectangle(0, 0, 1280, 720));
			this.battleModel = battleModel;
			mapView = new MapView(new Rectangle(0, 0, 1280, 720), battleModel.mapModel);			

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
		
		private function addedToStage(evt:Event):void {
			addChild(mapView);
			initUi();
			
			for each(var unit:UnitModel in battleModel.units) {
				mapView.addUnit(new UnitView(unit));
			}
		}
		
	}
}