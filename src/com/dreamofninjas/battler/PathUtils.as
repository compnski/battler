package com.dreamofninjas.battler
{
	public class PathUtils
	{
		public function PathUtils()
		{
		}
		
		
		// mapModel has getTerrainAt() ?
		// getAurasAt() ?
		
		// unit has getPathCost(terrain, tileAuras):int;
		// 999 is sentinel for unwalkable.
		
		public static function floodfill(start:Object, pathCost:Function, maxDistance:int):Array {
			var head:Node = new Node(start.r, start.c, 1, null);
			var nodes:Vector.<Node> = new Vector.<Node>(head);
			var tile:TileModel;
			var child:Node;
			var pathMap:Object = {};
			//north
			while (nodes.length > 0) {
				var node:Node = nodes.pop();
				if ( node.totalCost > maxDistance) {
					continue;
				}
				pathMap[[node.r, node.c]] = node;

				nodes.concat(new Node(node.r+1, node.c, 1, node),
					new Node(node.r-1, node.c, 1, node),
					new Node(node.r, node.c+1, 1, node),
					new Node(node.r, node.c-1, 1, node));
			}
			return null;
		}
	}
}


internal class Node {
	public var r:int;
	public var c:int;
	public var cost:int;
	public var totalCost:int;
	public var cheapestParent:Node;
	
	public function Node(r:int, c:int, cost:int, parent:Node) {
		this.r = r;
		this.c = c;
		this.cost = cost;
		this.totalCost = cost + (parent ? parent.totalCost : 0);
		this.cheapestParent = parent;
	}
}