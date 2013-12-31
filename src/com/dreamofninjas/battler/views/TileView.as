package com.dreamofninjas.battler.views
{
	import com.dreamofninjas.core.app.BaseView;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class TileView extends BaseView
	{ 
		protected var _backgroundImage:Image;
		
		public function TileView(tileId:int, backgroundTexture:Texture)
		{
			super();
			this.touchable = true;
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