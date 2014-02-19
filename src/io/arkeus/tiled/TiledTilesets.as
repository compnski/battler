package io.arkeus.tiled {
	import com.dreamofninjas.core.util.BaseLoader;
	import com.dreamofninjas.core.util.MultiLoader;
	import com.dreamofninjas.core.util.XmlLoader;
	
	import starling.events.Event;
	
	/**
	 * A container that holds all tilesets within the map.
	 */
	public class TiledTilesets extends BaseLoader {
		/** A map from tileset tileset name to tileset. */
		public var tilesets:Object = {};
		/** A vector containing all tilesets in the order defined. */
		public var tilesetsVector:Vector.<TiledTileset> = new <TiledTileset>[];
		
		protected var _allTerrainLoader:MultiLoader = new MultiLoader();
		protected var _allTilesetLoader:MultiLoader = new MultiLoader();
		protected var _loadPath:String;
		
		public function TiledTilesets(loadPath:String, tmx:XMLList) {
			_loadPath = loadPath;
			for (var i:uint = 0; i < tmx.length(); i++) {
				if ("@source" in tmx[i]) {
					var terrainPath:String = loadPath + tmx[i].@source;
					var terrainLoader:XmlLoader = new XmlLoader(terrainPath);
					terrainLoader.addEventListener(Event.COMPLETE,  createTilesetHandler(dirname(terrainPath), tmx[i]));
					_allTerrainLoader.add(terrainLoader);
				} else {
					addTileset(loadPath, tmx[i]);
				}
			}
		}

		public function getTile(tileId:int):TiledTile {
			var ts:TiledTileset = getTilesetForTile(tileId);
			if (getTilesetForTile(tileId).tiles[tileId] == null) {
				return null;
			}
			return getTilesetForTile(tileId).tiles[tileId];
		}
		
		public function getTerrainById(tileId:int, terrainId:String):TiledTerrain {
			return getTilesetForTile(tileId).terrainById[terrainId];
		}
		
		public function getTilesetForTile(tileId:int):TiledTileset {
			for each (var tileset:TiledTileset in tilesetsVector) {
				if ( tileset.firstGid <= tileId && tileId <= tileset.lastGid) {
					if(tileset == null) {
						trace("no tileset for " + tileId);
						throw new Error("");
					}
					return tileset;
				}
			}
			return null;
		}		
		
		private function createTilesetHandler(loadPath:String, tmx:XML):Function {
			return function (evt:Event):void {
				var xml:XML = evt.data as XML;
				xml.@firstgid = tmx.@firstgid;
				addTileset(loadPath, xml);
			}
		}
		
		public override function load(timeout:uint=0):void {
			super.load(timeout);
			_allTilesetLoader.addEventListener(Event.COMPLETE, function(evt:Event):void { loadComplete(this) });
			_allTerrainLoader.addEventListener(Event.COMPLETE, function(evt:Event):void { _allTilesetLoader.load() });
			_allTerrainLoader.load();
		}
		
		/**
		 * Given a <tileset> object, parses the tileset and adds it to both the map and vector.
		 *
		 * @param tmx The <tileset> object.
		 */
		private function addTileset(loadPath:String, tmx:XML):void {
			var tileset:TiledTileset = new TiledTileset(loadPath, tmx);
			tilesets[tileset.name] = tileset;
			tilesetsVector.push(tileset);
			_allTilesetLoader.add(tileset);
		}
		
		/**
		 * Gets a tileset by index.
		 *
		 * @param index The index into the vector.
		 * @return The tileset at the given index.
		 */
		public function getTileset(index:uint):TiledTileset {
			return tilesetsVector[index];
		}
		
		/**
		 * Gets a tileset by name.
		 *
		 * @param name The name of the tilset.
		 * @return The tileset with the given name.
		 */
		public function getTilesetByName(name:String):TiledTileset {
			return tilesets[name];
		}
		
		/**
		 * Returns the number of tilesets in this map.
		 *
		 * @return The number of tilesets.
		 */
		public function size():uint {
			return tilesetsVector.length;
		}
		
		/**
		 * Constructs a string containing the number of tilesets.
		 */
		public function toString():String {
			return size() + " tilesets";
		}
	}
}
