package io.arkeus.tiled {
	import com.dreamofninjas.core.util.AssetLoader;
	import com.dreamofninjas.core.util.BaseLoader;
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import starling.events.Event;

	/**
	 * A container holding properties for a single tileset within the map.
	 */
	public class TiledTileset extends BaseLoader {
		/** The first global tile id in the tileset. */
		public var firstGid:uint;
		public var lastGid:uint;
		/** The name of the tilset. */
		public var name:String;
		/** The maximum width of tiles in this tileset. */
		public var tileWidth:uint;
		/** The maximum height of tiles in this tileset. */
		public var tileHeight:uint;
		/** The spacing, in pixels, between the tiles in this tileset. */
		public var spacing:uint;
		/** The margin around the tiles in this tileset. */
		public var margin:uint;
		/** The offset, in pixels, for the tiles in this tileset. */
		public var tileOffset:Point;
		/** The properties of the tileset. */
		public var properties:TiledProperties;
		/** The tileset image. */
		public var image:TiledImage;
		/** A map from terrain name to terrains contained within this tileset. */
		public var terrain:Object;
		/** A map from terrain tile id to terrains contained within this tileset. */
		public var terrainById:Object = {};
		/** A map from gid to tile for all the non-standard tiles in the tileset. */
		public var tiles:Object;

		public var imageData:Bitmap;

 
		
    public function TiledTileset(loadPath:String, tmx:XML) {
      firstGid = tmx.@firstgid;
			name = tmx.@name;
			tileWidth = tmx.@tilewidth;
			tileHeight = tmx.@tileheight;
			spacing = "@spacing" in tmx ? tmx.@spacing : 0;
			margin = "@margin" in tmx ? tmx.@margin : 0;

			var offset:XMLList = tmx.tileoffset;
			tileOffset = offset.length() == 1 ? new Point(offset.@x, offset.@y) : new Point;

			image = new TiledImage(tmx.image);
			image.source = loadPath + image.source;
			terrain = loadTerrain(firstGid, tmx.terraintypes);
			tiles = loadTiles(firstGid, tmx.tile);
			for each(var t:TiledTerrain in terrain) {
				terrainById[t.id] = t;
			}
		}

		public override function load(timeout:uint=0):void {
			super.load(timeout);
			trace("Loading " + image.source);
			var imageLoader:AssetLoader = new AssetLoader(image.source);
			imageLoader.addEventListener(Event.COMPLETE, imageLoaded);
			imageLoader.load();
		}

		private function imageLoaded(evt:Event):void {
			imageData = evt.data as flash.display.Bitmap;
			loadComplete(this);
		}

		/**
		 * Given a tileset, loads all the terrains from the terraintypes object.
		 *
		 * @param tmx The terraintypes object.
		 * @return The map from terrain name to terrain.
		 */
		private static function loadTerrain(firstGid:uint, tmx:XMLList):Object {
			var terrain:Object = {};

			for (var i:uint = 0; i < tmx.terrain.length(); i++) {
				var node:TiledTerrain = new TiledTerrain(i, tmx.terrain[i]);
				node.tile += firstGid;
	
				terrain[node.name] = node;
			}

			return terrain;
		}

		/**
		 * Given a list of tiles, builds a map from gid to tile.
		 *
		 * @param tmx The XMLList of <tile> objects.
		 * @return The map from gid to tiles.
		 */
		private function loadTiles(firstGid:uint, tmx:XMLList):Object {
			var tiles:Object = {};

			for (var i:uint = 0; i < tmx.length(); i++) {
				var node:TiledTile = new TiledTile(tmx[i]);
				node.id += firstGid;
				tiles[node.id] = node;
        lastGid = Math.max(lastGid, node.id);
				trace("created tile " + node.id);
			}

			return tiles;
		}
	}
}
