package com.dreamofninjas.core.app
{
	import flash.geom.Rectangle;
	
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.utils.AssetManager;
	
	public class BaseView extends Sprite 
	{
		static protected const _assetManager:AssetManager = new AssetManager();
		protected var juggler:Juggler;
		public var paused:Boolean = false; // set to pause time advancing on this object
		
		
		public function get z():int {
			return 0;
		}
		
		public function BaseView(clipRect:Rectangle=null) {
			super();
			this.clipRect = clipRect;
			this.juggler = Starling.juggler;
			this.touchable = false;
	}
}
}