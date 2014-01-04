package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.battler.MapObjects;
	import com.dreamofninjas.battler.MapProperties;
	import com.dreamofninjas.core.app.BaseModel;
	import com.dreamofninjas.core.ui.GPoint;
	
	import flash.utils.Dictionary;
	
	import io.arkeus.tiled.TiledLayer;
	import io.arkeus.tiled.TiledMap;
	import io.arkeus.tiled.TiledObject;
	import io.arkeus.tiled.TiledObjectLayer;
	import io.arkeus.tiled.TiledTileLayer;
	
	public class MapModel extends BaseModel
	{
		// Raw map data, int of IDs
		public var terrainData:Array; 
		public var rows:int; // in tiles
		public var cols:int; // in tiles
		
		// Map of objects from their type to a vector of contents;
		private var _typeMap:Dictionary = new Dictionary();
		
		private var _map:TiledMap;
		private var _tileFactory:TileFactory;
		private var _tiles:Object = new Object();
		
		public function get factionNames():Array {
			return ["Player", "Enemy"]
		};
		
		public function getTileAt(loc:GPoint):TileModel {
			if (!(loc in _tiles)) {
				_tiles[loc] = _tileFactory.get(loc);
			}
			return _tiles[loc];
		}
		
		public function MapModel(map:TiledMap) {
			super();
			_map = map;
			this.rows = map.height;
			this.cols = map.width;
			this._tileFactory = new TileFactory(map);
			// find terrain layer
			for each (var layer:TiledLayer in map.layers.getAllLayers()) {
				if (layer is TiledTileLayer && layer.name == "Terrain") {
					terrainData = (layer as TiledTileLayer).data;
				}
				if (layer is TiledObjectLayer) {
					loadObjects(layer as TiledObjectLayer);
				}
			}
			if (terrainData == null) {
				throw new Error("Failed to load any terrain for map");
			}
		}	
				
		public function getSpawnsForFaction(faction:String):Vector.<TiledObject> {
			return (_typeMap[MapObjects.SPAWN] as Vector.<TiledObject>).filter(
				function(item:TiledObject, i:int, v:Vector.<TiledObject>):Boolean { return item.properties.get(MapProperties.FACTION) == faction; });
		}
		
		private function loadObjects(layer:TiledObjectLayer):void {
			for (var type:String in layer.typeMap) {
				var obj:Vector.<TiledObject> = layer.typeMap[type];
				
				// Apply layer properties to tile
				obj.forEach(function(item:TiledObject, index:int, vector:Vector.<TiledObject>):void {
					item.properties.extend(layer.properties);
				});
				
				if (_typeMap.hasOwnProperty(type)) {
					_typeMap[type] = (_typeMap[type] as Vector.<TiledObject>).concat(obj);
				} else {
					_typeMap[type] = obj;
				}
			}
		}		
	}
}