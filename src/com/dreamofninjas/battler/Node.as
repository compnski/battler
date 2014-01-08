package com.dreamofninjas.battler
{
	import com.dreamofninjas.core.ui.GPoint;

	public class Node {
		public var cost:int;
		public var totalCost:int;
		public var cheapestParent:Node;
		public var paths:int = 1;
		public var gpoint:GPoint;
		
		public function get r():int {
			return gpoint.r;
		}
		public function get c():int {
			return gpoint.c;
		}
		
		public function Node(loc:GPoint, cost:int, parent:Node) {
			this.gpoint = loc
			this.paths = 1;
			this.cost = cost;
			this.totalCost = cost + (parent != null ? parent.totalCost : 0);
			this.cheapestParent = parent;
		}
		
		public function toString():String {
			return JSON.stringify(this);
		}
		
	}
}
