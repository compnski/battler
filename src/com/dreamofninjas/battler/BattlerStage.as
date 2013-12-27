package com.dreamofninjas.battler
{
	import com.dreamofninjas.UnitDetailView;
	import com.dreamofninjas.core.app.BaseView;
	import com.dreamofninjas.core.util.MultiLoader;
	
	import flash.geom.Rectangle;
	
	import io.arkeus.tiled.TiledMap;
	
	import starling.display.Quad;
	import starling.events.Event;

	public class BattlerStage extends BaseView {
		protected var initialAssetLoader:MultiLoader = new MultiLoader();
		protected var mapLoader:MapLoader;
		private var q:Quad;
		
		private var _mapModel:MapModel;
		private var _mapView:MapView;
		
		private var _timerController:*;
		private var _timerView:BaseView;
		
		private var _targetUnitView:UnitDetailView;
		private var _selectedUnitView:UnitDetailView;
		
		private var _item:BattleModel;
		
		public function BattlerStage()
		{
			super(new Rectangle(0, 0, 1280, 720));
			this.y = 50;
			trace("BattlerStage");
			mapLoader = new MapLoader("assets/maps/", "test.tmx");
			mapLoader.addEventListener(Event.COMPLETE, mapLoaded);
						
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(evt:Event):void {
			this.width = 1280;
			this.height = 720;

			mapLoader.load();

		}

		protected function mapLoaded(evt:Event):void {
			trace("loaded!");
			var map:TiledMap = evt.data.map;
			var atlases:Object = evt.data.atlases;
			for each (var atlas:Object in atlases) {
				_assetManager.addTextureAtlas(atlas.name, atlas.textures);
			}
			var mapModel:MapModel = new MapModel(map);
			var mapView:MapView = new MapView(new Rectangle(0, 0, 1280, 720), mapModel);			
			addChild(mapView);

			var playerModel:PlayerModel = new PlayerModel();
			var factions:Vector.<FactionModel> = new Vector.<FactionModel>;
			_item = new BattleModel(mapModel, playerModel, factions);
			
			_targetUnitView = new TargetUnitDetailView(_item, null);
			_targetUnitView.x = 96;
			_targetUnitView.y = 64;
			addChild(_targetUnitView);	
			
			_selectedUnitView = new CurrentUnitDetailView(_item, null);
			_selectedUnitView.x = 892;
			_selectedUnitView.y = 64;
			addChild(_selectedUnitView);
			
			
			
			sortChildren(function(a:BaseView, b:BaseView):int {
				return a.z - b.z;
			});
			
			var bf:BattleFlow = new BattleFlow(_item, this);
			new InitialFlow(bf);			
		}

		private function mazpLoaded(evt:Event):void {
			trace("done");
		}

	}
}
