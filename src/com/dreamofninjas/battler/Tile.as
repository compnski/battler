package com.dreamofninjas.battler
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class Tile extends Sprite
	{ 
		protected var _backgroundImage:Image;
		
		public function Tile(tileId:int, backgroundTexture:Texture)
		{
			super();
			this.width = 32;
			this.height = 32;
			if (backgroundTexture != null) {
				_backgroundImage = new Image(backgroundTexture);
				addChild(_backgroundImage);
			} else {
				trace("No texture for tile_" + tileId);
			}
		}
	}
}