package com.dreamofninjas.battler
{
	import starling.textures.Texture;

	public class TileTextureFactory {
	
		protected var _atlases:Array;  // Sorted in reverse by firstId

		public function TileTextureFactory(atlases:Array) {
			_atlases = atlases.sortOn("firstGid", Array.NUMERIC | Array.DESCENDING);
		}
		
		public function getTile(id:uint):Texture {
			for (var atlas:Object in _atlases) {
				if (id > atlas.firstId) {
					return atlas.textures.getTexture(id);
				}
			}
			return null;
		}
	}
}