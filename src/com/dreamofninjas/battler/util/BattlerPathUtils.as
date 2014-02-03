package com.dreamofninjas.battler.util
{
	import com.dreamofninjas.battler.models.MapModel;
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.core.app.TileModel;
	import com.dreamofninjas.core.engine.Terrain;
	import com.dreamofninjas.core.ui.GPoint;

	public class BattlerPathUtils
	{
		public function BattlerPathUtils()
		{
		}
		
				// mapModel has getTerrainAt() ?
		// getAurasAt() ?
		
		// unit has getPathCost(terrain, tileAuras):int;
		// 999 is sentinel for unwalkable.
		
		private static const terrainCostMap:Object = {
			"Lava": 999,
			"Water": 999,
			"Sand": 2
		};
				
		/**
		 * Returns the standard cost of moving across any tile.
		 * 
		 */
		private static function getBaseTerrainCost(terrain:String):uint {
			if (terrain in terrainCostMap) {
				return terrainCostMap[terrain];
			}
			return 1;
		}
		
		public static function getTileCost(unit:UnitModel, tile:TileModel):uint {
			var cost:int = tile.terrain.map(function(item:Terrain, i:int, v:Array):int {
				return getBaseTerrainCost(item.name);
			}).sort(Array.DESCENDING | Array.NUMERIC)[0];
			return cost;
		}
		
		public static function getStdPathCostFunction(unit:UnitModel, mapModel:MapModel):Function {
			return function(loc:GPoint):int {
				var unitOnTile:UnitModel = mapModel.getUnitAt(loc)
				if (unitOnTile != null && unitOnTile.faction != unit.faction) {
					return 999;
				}
				return BattlerPathUtils.getTileCost(unit, mapModel.getTileAt(loc));
			}
		}
	}
}
