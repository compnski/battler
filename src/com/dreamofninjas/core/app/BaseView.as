package com.dreamofninjas.core.app
{
	import flash.geom.Rectangle;
	
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.utils.AssetManager;
	import com.dreamofninjas.core.engine.ViewHandle;
	
	public class BaseView extends Sprite implements ViewHandle
	{
		static protected const _assetManager:AssetManager = new AssetManager();
		protected var juggler:Juggler;
		public var paused:Boolean = false; // set to pause time advancing on this object
		
		
		public function loadTextures(atlases:Object):void {
			for each (var atlas:Object in atlases) {
				_assetManager.addTextureAtlas(atlas.name, atlas.textures);
			}
		}
		
		public function get z():int {
			return 0;
		}
		
		public function release():void {
			this.removeFromParent();
			this.dispose();
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