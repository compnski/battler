package com.dreamofninjas.core.engine
{
	import com.dreamofninjas.core.util.BaseLoader;
	import com.dreamofninjas.core.util.TmxMapLoader;
	
	import io.arkeus.tiled.TiledMap;
	import io.arkeus.tiled.TiledTileset;
	
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class MapLoader extends BaseLoader {
		private var _tmxLoader:TmxMapLoader;
		private var _assetPath:String;
		private var _tiledMap:TiledMap;
		
		
		public function MapLoader(assetPath:String, mapName:String) {
			_assetPath = assetPath;	
			_tmxLoader = new TmxMapLoader(assetPath, mapName);
		}
		
		public override function load(timeout:uint=0):void {
			super.load(timeout);
			_tmxLoader.addEventListener(Event.COMPLETE, tmxMapLoaded);
			_tmxLoader.load();
		}
		
		private function tmxMapLoaded(evt:Event):void {
			var atlases:Array = new Array();
			_tiledMap = evt.data as TiledMap;
			for each (var tileset:TiledTileset in _tiledMap.tilesets.tilesets) {
				 atlases.push({textures: loadAtlas(tileset), firstId:tileset.firstGid, name:tileset.name});
			}
			trace('map loaded');
			loadComplete({atlases: atlases, tiledMap:_tiledMap});
		}
		
		private function loadAtlas(tileset:TiledTileset):TextureAtlas {
			trace("loading atlas " + tileset.name);
			var xml:XML = SpriteManager.getSpriteXml(tileset.image.source, "tile", tileset.firstGid, tileset.image.height, tileset.image.width, tileset.tileWidth, tileset.tileHeight, tileset.margin, tileset.spacing)
			//var newxml:XML = XML(xml.TextureAtlas);
			return new TextureAtlas(Texture.fromBitmap(tileset.imageData), xml);
			
			trace("done with atlas, dispatching");
		}
	}
}