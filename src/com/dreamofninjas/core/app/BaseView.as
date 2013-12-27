package com.dreamofninjas.core.app
{
	import flash.geom.Rectangle;
	
	import starling.display.Sprite;
	import starling.utils.AssetManager;
	
	public class BaseView extends Sprite
	{
		static protected const _assetManager:AssetManager = new AssetManager();
		
		public function get z():int {
			return 0;
		}
		
		public function BaseView(clipRect:Rectangle=null)
		{
			super();
			this.clipRect = clipRect;
		}
	}
}