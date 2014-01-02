package com.dreamofninjas.core.ui
{
	import starling.display.Button;
	import starling.textures.Texture;
	
	public class StandardButton extends Button
	{
		// width=-1 auto sizes based on text width.
		public function StandardButton(text:String, width:int=-1, height:int = 30, color:uint=0xF0A3A3A3)
		{
			if (width == -1) {
				width = 70; //TODO: Fix this to auto-size
			}
			var upState:Texture = Texture.fromColor(width, height, color);
			super(upState, text);
		}
	}
}