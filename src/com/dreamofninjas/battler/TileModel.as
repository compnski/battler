package com.dreamofninjas.battler
{
	import com.dreamofninjas.core.app.BaseModel;
	
	public class TileModel extends BaseModel
	{
		public function TileModel() {
			super();
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