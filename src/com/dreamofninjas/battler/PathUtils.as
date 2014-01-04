package com.dreamofninjas.battler
{
	import com.dreamofninjas.battler.models.Terrain;
	import com.dreamofninjas.battler.models.TileModel;
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.core.ui.GPoint;

	public class PathUtils
	{
		public function PathUtils()
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
		
		private static function getNodeHelper(pathMap:Object, loc:GPoint, parent:Node, pathCost:Function): Node {
			var cost:int = pathCost(loc);
			var node:Node = pathMap[loc];
			if (node == null) {
				node = new Node(loc, cost, parent);
			} else {
				node.paths++;
				if (node.cost != cost) {
					trace("Bad cost for " + loc + ",\n " + node); 					
					throw new Error("Bad cost");
				}
				if (parent.totalCost + cost < node.totalCost) {
					node.totalCost = parent.totalCost + cost;
					node.cheapestParent = parent;
				}
			}
			return node;
		}
		
		/**
		 * Returns an array of GPoints representing a path from start to dest.
		 * Throws an exception if start and dest are not in nodeMap
		 */
		public static function getPath(nodeMap:Object, start:GPoint, dest:GPoint):Array {
			trace("Find path from " + start + " to " + dest);
			if(!(start in nodeMap && dest in nodeMap)) {
				throw new Error("Tried to find a path to or from a node not in the map");
			}
			var path:Array = new Array();
			if (start == dest) {
				return path;
			}
			var breakCnt:int = 0; // stop loops
			var node:Node = nodeMap[dest];
			while (node && node.gpoint != start) {
				path.push(node.gpoint);
				node = node.cheapestParent;
				if (breakCnt++ > 100) {
					throw new Error("Pathfinding more than 100 steps, probably a loop");
				}
			}
			
			return path;
		}
		
		public static function floodFill(start:GPoint, pathCost:Function, maxDistance:int):Object {
			var head:Node = new Node(start, pathCost(start), null);
			
			var nodes:Vector.<Node> = new Vector.<Node>();
			nodes.push(head);
			var tile:TileModel;
			var pathMap:Object = {};
			
			var child:Node;
			
			while (nodes.length > 0) {
				var node:Node = nodes.pop();
				if ( node.totalCost > maxDistance) {
					continue;
				}
				
				var loc:GPoint = node.gpoint;
				pathMap[loc] = node;				
				//trace(loc);
				
				child = getNodeHelper(pathMap, loc.up(), node, pathCost);
				if (child && child.paths == 1) {
					nodes.push(child);
				}
				child = getNodeHelper(pathMap, loc.down(), node, pathCost);
				if (child && child.paths == 1) {
					nodes.push(child);
				}
				child = getNodeHelper(pathMap, loc.right(), node, pathCost);
				if (child && child.paths == 1) {
					nodes.push(child);
				}
				child = getNodeHelper(pathMap, loc.left(), node, pathCost);
				if (child && child.paths == 1) {
					nodes.push(child);
				}
			}
			return pathMap;
		}
	}
}
