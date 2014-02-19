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
		
		public function OverworldView(level:LevelModel)
		{
			super(new Rectangle(0, 0, 1280, 720));
			this._level = level;
			this.touchable = true;
			this._mapView = new MapView(new Rectangle(0, 0, 1280, 720), level.mapModel);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(evt:Event):void {
			addChild(_mapView);
			//flatten();
		}
		
	}
}