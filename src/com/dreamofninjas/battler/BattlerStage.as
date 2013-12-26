package com.dreamofninjas.battler
{
	import com.dreamofninjas.core.util.MultiLoader;
	
	import io.arkeus.tiled.TiledLayer;
	import io.arkeus.tiled.TiledMap;
	import io.arkeus.tiled.TiledTileLayer;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;

	public class BattlerStage extends Sprite {
		protected var initialAssetLoader:MultiLoader = new MultiLoader();
		protected var mapLoader:MapLoader;
		private var q:Quad;
		protected var _assetManager:AssetManager = new AssetManager();
		//proteted var _tileLayer:TileLayer = new TileLayer();
		
		public function BattlerStage()
		{
			super();
			//this.width = 1024;
			//this.height = 768;
			trace("BattlerStage");
			//initialAssetLoader.addEventListener(Event.COMPLETE, allLoaded);
			//initialAssetLoader.addEventListener(ErrorEvent.ERROR, loadFailed);
			mapLoader = new MapLoader("assets/maps/", "test.tmx");
			mapLoader.addEventListener(Event.COMPLETE, allLoaded);

			//initialAssetLoader.add(mapLoader);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(evt:Event):void {
			//initialAssetLoader.load();
			mapLoader.load();
		}

		protected function allLoaded(evt:Event):void {
			trace("loaded!");
			var map:TiledMap = evt.data.map;
			var atlases:Object = evt.data.atlases;
			for each (var atlas:Object in atlases) {
				_assetManager.addTextureAtlas(atlas.name, atlas.textures);
			}
			for each(var layer:TiledLayer in map.layers.getVisibleLayers()) {
				var tileLayer:TileLayer = new TileLayer();
				tileLayer.width = layer.width * 32;
				tileLayer.height = layer.height * 32;
				trace(layer.width);
				trace(tileLayer.width);
				trace(tileLayer.height);
				var data:Array = (layer as TiledTileLayer).data;
				var rows:int = data.length;
				var cols:int = data[0].length;
				var id:int = 0;
				trace("Loading layer " + layer.name);
				for (var r:uint = 0; r < rows; r++) {
					for (var c:uint = 0; c < cols; c++) {
						var tileId:int = data[r][c];
						//tileId = (id++) % 464;
						var tile:Tile = new Tile(tileId,_assetManager.getTexture("tile_"+tileId));
						tile.x = c * tile.width;
						tile.y = r * tile.height;
						tileLayer.addChild(tile);
					}
				}
				tileLayer.y = 50;
				tileLayer.flatten();
				tileLayer.drawGrid();
				tileLayer.flatten();
				addChild(tileLayer);
			}
		}

		private function mapLoaded(evt:Event):void {
			trace("done");
		}

	}
}
