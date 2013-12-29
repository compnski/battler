package com.dreamofninjas.battler
{
	
	/**
	 * Route holds a path for a given unit to a given destination.
	 * It is a series of rook moves.
	 * It holds onto the unit and map so it can recalculate.
	 * destination is an object {r:r, c:c}
	 */
	
	public class Route { 
	
		private var map:MapModel = map;
		private var unit:UnitModel = unit;
		private var destination:Object;

		public function Route(map:MapModel, unit:UnitModel, destination:Object) {
			this.map = map;
			this.unit = unit;
			this.destination = destination;
		}
		
		/**
		 * Calculates the route, returns the number of remaining steps.
		 */
		public function calculate():int {
			
			return 0;
		}
		
	}
}