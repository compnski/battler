package com.dreamofninjas.battler.util
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
			loadComplete({atlases: atlases, map:_tiledMap});
		}
		
		private function loadAtlas(tileset:TiledTileset):TextureAtlas {
			trace("loading atlas " + tileset.name);
			var numRows:uint = (tileset.image.height - tileset.margin) / (tileset.tileHeight + tileset.spacing);
			var numCols:uint = (tileset.image.width - tileset.margin) / (tileset.tileWidth + tileset.spacing);
			var id:int = tileset.firstGid;
			
			var xml:XML = <Atlas></Atlas>;
			
			xml.appendChild(<TextureAtlas imagePath={tileset.image.source}></TextureAtlas>);
			
			for (var r:int = 0; r < numRows; r++) {
				for (var c:int = 0; c < numCols; c++) {
					xml.child("TextureAtlas").appendChild(<SubTexture name={"tile_" + id} x = {(tileset.margin + (c * (tileset.tileWidth + tileset.spacing)))} y={(tileset.margin + (r * (tileset.tileHeight + tileset.spacing))) } width={tileset.tileWidth} height={tileset.tileHeight}/>);
					id++;
				}
			}
			
			var newxml:XML = XML(xml.TextureAtlas);
			return new TextureAtlas(Texture.fromBitmap(tileset.imageData), newxml);
			
			trace("done with atlas, dispatching");
		}

	}
}