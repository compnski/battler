package com.dreamofninjas.battler.views
{
	import com.dreamofninjas.battler.models.LevelModel;
	import com.dreamofninjas.core.app.BaseView;
	
	import flash.geom.Rectangle;
	
	import starling.events.Event;
	
	public class OverworldView extends BaseView
	{
		private var _level:LevelModel;
		public var _mapView:MapView;
		
		public function OverworldView(level:LevelModel, mapView:MapView)
		{
			super(new Rectangle(0, 0, 1280, 720));
			this._level = level;
			this.touchable = true;
			this._mapView = mapView;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(evt:Event):void {
			addChild(_mapView);
			//flatten();
		}
		
	}
}