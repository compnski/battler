package com.dreamofninjas.battler.flows
{
	import com.dreamofninjas.battler.levels.Level1;
	import com.dreamofninjas.battler.levels.LevelLoader;
	import com.dreamofninjas.battler.levels.LevelOverworld;
	import com.dreamofninjas.battler.levels.LevelShop1;
	import com.dreamofninjas.battler.models.BattleModel;
	import com.dreamofninjas.battler.models.LevelModel;
	import com.dreamofninjas.battler.models.MapModel;
	import com.dreamofninjas.battler.models.PlayerModel;
	import com.dreamofninjas.battler.views.MapView;
	import com.dreamofninjas.core.app.BaseFlow;
	import com.dreamofninjas.core.app.BaseView;
	
	import flash.geom.Rectangle;
	
	import starling.events.Event;
	
	public class LoadLevelFlow extends BaseFlow
	{
		
		private var _loader:LevelLoader;
		private var _playerModel:PlayerModel;
		private var _baseView:BaseView;
		
		public function LoadLevelFlow(baseView:BaseView, playerModel:PlayerModel, levelName:String)
		{
			super();
			this._playerModel = playerModel;
			_loader = getLoader(levelName);
			this._baseView = baseView;
		}
		
		public override function Execute():void {
			super.Execute();
			_loader.addEventListener(Event.COMPLETE, levelLoaded);
			_loader.load();
		}
		
		private function levelLoaded(evt:Event):void {
			var levelModel:LevelModel = evt.data.levelModel;
			var mapModel:MapModel = evt.data.mapModel;

			var mapView:MapView = new MapView(new Rectangle(0, 0, 1280, 720), mapModel, evt.data.assetManager);
			trace("Loading world of type " + levelModel.worldType)
			switch(levelModel.worldType) {
				case LevelModel.BATTLE:
					var battleModel:BattleModel = new BattleModel(mapModel);
					onRestored(Complete);
					setNextFlow(new BattleFlow(levelModel, battleModel, _baseView, mapView));
				break;
				case LevelModel.OVERWORLD:
					onRestored(Complete);
					setNextFlow(new OverworldFlow(_playerModel, levelModel, _baseView, mapView));
					break;
			default:
				throw new Error("Don't know how to deal with worlds of type " + levelModel.worldType);
			}
		}
		
		private function getLoader(name:String):LevelLoader {
			trace("loading " + name);
			switch(name) {
				case "overworld":
					return LevelOverworld.Loader(_playerModel);
					break;
				case "shop1":
					return LevelShop1.Loader(_playerModel);
					break;
				case "level1":
					return Level1.Loader(_playerModel);
					break;
			}
			throw new Error("No level found named " + name);
		}		
	}
}