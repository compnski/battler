package com.dreamofninjas.battler
{
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
			this.cost = cost;
			this.totalCost = cost + (parent ? parent.totalCost : 0);
			this.cheapestParent = parent;
		}
		
		public function toString():String {
			return JSON.stringify(this);
		}
		
	}
}