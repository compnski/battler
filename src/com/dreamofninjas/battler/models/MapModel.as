package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.core.app.BaseModel;
	
	import flash.utils.Dictionary;
	
	import io.arkeus.tiled.TiledLayer;
	import io.arkeus.tiled.TiledMap;
	import io.arkeus.tiled.TiledObject;
	import io.arkeus.tiled.TiledObjectLayer;
	import io.arkeus.tiled.TiledTileLayer;
	import com.dreamofninjas.battler.MapObjects;
	import com.dreamofninjas.battler.MapProperties;
	import com.dreamofninjas.battler.Route;
	
	public class MapModel extends BaseModel
	{
		// Raw map data, int of IDs
		public var terrainData:Array; 
		public var rows:int; // in tiles
		public var cols:int; // in tiles
	
		// Map of objects from their type to a vector of contents;
		protected var _typeMap:Dictionary = new Dictionary();
		
		protected var _map:TiledMap;
		
		public function get factionNames():Array {
			return ["Player", "Enemy"]
		};
		
		public function getTileAt(r:int, c:int):TileModel {
			return new TileModel();
		}
		
		public function MapModel(map:TiledMap) {
			super();
			_map = map;
			this.rows = map.height;
			this.cols = map.width;
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
		
		public function getPathCost(fromR, fromC, toR, toC:int):int {	
			return Math.abs(toR - fromR) + Math.abs(toC - fromC);
		}
		
		/**
		 * destination is an object {r:r, c:c}
		 */
		
		public function getRouteForUnit(unit:UnitModel, destination:Object):Route {
			return new Route(this, unit, destination);
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