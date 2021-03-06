package com.dreamofninjas.core.engine
{
	import com.dreamofninjas.core.app.TileModel;
	import com.dreamofninjas.core.ui.GPoint;
	
	import flash.utils.Dictionary;

	public class PathUtils
	{
		public function PathUtils()
		{
		}
		/**
		 * Returns an array of GPoints representing a path from start to dest.
		 * Throws an exception if start and dest are not in nodeMap
		 */
		public static function getPath(nodeMap:Object, start:GPoint, dest:GPoint):Array {
			if(!(dest in nodeMap)) {
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
		
		private static function getNodeHelper(pathMap:Dictionary, loc:GPoint, parent:Node, pathCost:Function, maxDistance:uint): Node {
			if (loc.r < 0 || loc.c < 0) {
				return null;
			}

			var cost:int = pathCost(loc);
			var node:Node = pathMap[loc];
			if (node == null) {
				node = new Node(loc, cost, parent);
				node.reachable = (node.totalCost <= maxDistance);
				pathMap[loc] = node;
				return node;
			} else {
				node.paths++;
				if (node.cost != cost && node.cost != 0) { //origin  is special and costs 0
					trace("Bad cost for " + loc + ",\n " + node); 					
					throw new Error("Bad cost");
				}
				if ((parent.totalCost + cost) < node.totalCost) {
					node.totalCost = parent.totalCost + cost;
					node.reachable = node.totalCost <= maxDistance;
					node.cheapestParent = parent;
					return node;
				}
			}
			return null; // Wasn't fastest p
		}
		
		public static function floodFill(start:GPoint, pathCost:Function, maxDistance:uint):Dictionary {
			var nodes:Vector.<Node> = new Vector.<Node>();
			var pathMap:Dictionary = new Dictionary();

			
			var head:Node = new Node(start, 0, null);
			pathMap[start] = head;
			nodes.push(head);
			var tile:TileModel;
			
			var child:Node;
			var breakCnt:int = 0;
			while (nodes.length > 0) {
				
				var node:Node = nodes.shift();
				if ( node.totalCost > maxDistance) {
					continue;
				}
				if (breakCnt++ > 50000) {
					throw new Error("WARNING: More than 1000 iterations in path finding, quitting");
					return null;
				}

				var loc:GPoint = node.gpoint;
				
				child = getNodeHelper(pathMap, loc.up(), node, pathCost, maxDistance) ;
				if (child && child.paths == 1 && child.totalCost <= maxDistance) {
					nodes.push(child);
				}
				child = getNodeHelper(pathMap, loc.down(), node, pathCost, maxDistance);
				if (child && child.paths == 1 && child.totalCost <= maxDistance) {
					nodes.push(child);
				}
				child = getNodeHelper(pathMap, loc.right(), node, pathCost, maxDistance);
				if (child && child.paths == 1 && child.totalCost <= maxDistance) {
					nodes.push(child);
				}
				child = getNodeHelper(pathMap, loc.left(), node, pathCost, maxDistance);
				if (child && child.paths == 1 && child.totalCost <= maxDistance) {
					nodes.push(child);
				}
			}
			//prune:
			var prunedMap:Dictionary = new Dictionary();
			for (var l:GPoint in pathMap) {
				if (pathMap[l].reachable) {
					prunedMap[l] = pathMap[l];
				}
			}
			return prunedMap;
		}
	}
}
