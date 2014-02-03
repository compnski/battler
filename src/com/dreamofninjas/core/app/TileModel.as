package com.dreamofninjas.core.app
{
	import com.dreamofninjas.core.ui.GPoint;
	
	public class TileModel extends BaseModel {

		private var _terrain:Array;
		public var loc:GPoint;
		
		public function get terrain():Array {
			return _terrain;
		}
		
		public function TileModel(loc:GPoint,  terrain:Array) {
			super();
			this.loc = loc;
			this._terrain = terrain;
		}
		// gets all tiles from map
		// merges all properties?
		
		public function getTerrain():String {
			return "";
		}
		
		public function getTileAuras():Vector.<String> {
			return new Vector.<String>();
		}	
	}
}
