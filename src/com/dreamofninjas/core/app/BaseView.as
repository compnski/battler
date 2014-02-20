package com.dreamofninjas.core.app
{
	import com.dreamofninjas.core.engine.ViewHandle;
	
	import flash.geom.Rectangle;
	
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Sprite;
	
	public class BaseView extends Sprite implements ViewHandle
	{
		protected var juggler:Juggler;
		public var paused:Boolean = false; // set to pause time advancing on this object
				
		public function get z():int {
			return 0;
		}
		
		public function release():void {
			this.removeChildren(0, -1, true);
			removeFromParent(true);
			this.removeEventListeners();
		}
		
		public function BaseView(clipRect:Rectangle=null) {
			super();
			this.clipRect = clipRect;
			this.juggler = Starling.juggler;
			this.touchable = false;
		}
		
		public function show():void {
			this.visible = true;
		}
		
		public function hide():void {
			this.visible = false;
		}
	}
}