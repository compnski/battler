package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.battler.events.UnitEvent;
	import com.dreamofninjas.core.app.BaseModel;
	import com.dreamofninjas.core.ui.GPoint;
	
	import io.arkeus.tiled.TiledLayer;
	import io.arkeus.tiled.TiledMap;
	import io.arkeus.tiled.TiledTileLayer;
	
	import starling.events.Event;
	import com.dreamofninjas.core.engine.TileFactory;
	import com.dreamofninjas.core.app.TileModel;
	
	public class MapModel extends BaseModel
	{
		// Raw map data, int of IDs
		public var terrainData:Array = new Array(); 
		public var rows:int; // in tiles
		public var cols:int; // in tiles
				
		private var _map:TiledMap;
		private var _tileFactory:TileFactory;
		private var _tiles:Object = new Object();
		
		private var _units:Vector.<UnitModel>;
		
		public function addUnit(unit:UnitModel):void {
			_units.push(unit);
			// Bubble
			unit.addEventListener(UnitEvent.ACTIVATED, dispatchEventIfBubbles);
			unit.addEventListener(UnitEvent.DIED, dispatchEventIfBubbles);

			unit.addEventListener(UnitEvent.DIED, unitDied);
		}
		
		public function get factionNames():Array {
			return ["Player", "Enemy"]
		};
		
		public function get units():Vector.<UnitModel> {
			return _units;
		}
		
		public function getUnitAt(loc:GPoint):UnitModel {
			for each(var unit:UnitModel in units) {
				if (unit.r == loc.r && unit.c == loc.c) {
					return unit;
				}
			}
			return null;
		}
		
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
			this._units = new Vector.<UnitModel>();
			this._tileFactory = new TileFactory(map);
			// find terrain layer
			for each (var layer:TiledLayer in map.layers.getAllLayers()) {
				if (layer is TiledTileLayer && (layer as TiledTileLayer).drawable) {
					terrainData.push((layer as TiledTileLayer).data);
				}
			}
			if (terrainData == null) {
				throw new Error("Failed to load any terrain for map");
			}
		}
				
		private function unitDied(evt:Event):void {
			trace('unit died in map model')
			var unit:UnitModel = evt.target as UnitModel;
			unit.removeEventListener(UnitEvent.DIED, unitDied);
			var unitIdx:int = units.indexOf(unit);
			if (unitIdx < 0) {
				return;
			}

			units.splice(unitIdx, 1);
		}	
	}
}