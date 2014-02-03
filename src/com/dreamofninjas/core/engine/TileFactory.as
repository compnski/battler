package com.dreamofninjas.core.engine
{
	import com.dreamofninjas.core.ui.GPoint;
	
	import flash.utils.Dictionary;
	
	import io.arkeus.tiled.TiledMap;
	import io.arkeus.tiled.TiledProperties;
	import io.arkeus.tiled.TiledTerrain;
	import io.arkeus.tiled.TiledTile;
	import io.arkeus.tiled.TiledTileLayer;
	import com.dreamofninjas.core.app.TileModel;

	public class TileFactory {
		
		private var map:TiledMap;
		
		private var tileMap:Dictionary = new Dictionary();
		private var terrainMap:Dictionary = new Dictionary();;
		private static const IMPASSABLE_TERRAIN:Array = new Array();
		
		/* static */
		{
			TileFactory.IMPASSABLE_TERRAIN.push(new Terrain("Void",new TiledProperties(new XMLList())));
		}
		
		
		public function TileFactory(map:TiledMap)	{
			this.map = map;	
			// load tilesets?
		}
		
		public function get(loc:GPoint):TileModel {
			var terrain:Array = new Array();
			
			for each(var layer:TiledTileLayer in map.layers.getTileLayers()) {
				var tileId:int = layer.data[loc.r][loc.c];
				if (tileId == 0) {
					continue;
				}
				var tile:TiledTile = getTilesetTile(tileId);
				if (tile == null) {
					throw new Error("TileId " + tileId + " not found in any tileset.");
				}
				for each(var s:String in tile.rawTerrain.split(",")) {
					var t:Terrain = getTerrain(tileId, s);
					if (t) {
						terrain.push(t);
					}
				}
			}
			return new TileModel(loc, terrain);
		}
		
		public function getTilesetTile(tileId:int):TiledTile {
			if (!(tileId in tileMap)) {
				var t:TiledTile = map.tilesets.getTile(tileId);
				if (t == null) {
					return null;
				}
				tileMap[tileId] = map.tilesets.getTile(tileId);
			}
				return tileMap[tileId];
		}

		public function getTerrain(tileId:int, terrain:String):Terrain {
		if (!(terrain in terrainMap)) {
			var t:TiledTerrain = map.tilesets.getTerrainById(tileId, terrain);
			terrainMap[t.name] = new Terrain(t.name, t.properties);
		}
			return terrainMap[t.name];		
		}	
	}
}

 