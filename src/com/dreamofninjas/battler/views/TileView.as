package com.dreamofninjas.battler.views
{
	import starling.display.Button;
	import starling.textures.Texture;
	
	public class TileView extends Button
	{ 
		//private var _backgroundTexture:RenderTexture;
		
		public var r:int;
		public var c:int;
		
		public function TileView(tileId:int, r:int, c:int, backgroundTexture:Texture)
		{
			this.touchable = true;
			this.r = r;
			this.c = c;		
			super(backgroundTexture, "");//, _backgroundTexture);
		}
	}
}