package com.dreamofninjas.core.engine
{	
	import com.dreamofninjas.core.util.AssetLoader;
	
	import flash.display.Bitmap;
	
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;


	public class SpriteManager extends EventDispatcher
	{
		private static var _instance:SpriteManager;
		private var _assetManager:AssetManager = new AssetManager();
		public function SpriteManager(singleton:Singleton)
		{
			super();
			loadSprite(getSpriteXml("assets/sprites/crystal_blue.png", "crystal_blue", 0, 32, 256, 32, 32, 0, 0));
			loadSprite(getSpriteXml("assets/sprites/crystal_green.png", "crystal_green", 0, 32, 256, 32, 32, 0, 0));	
			loadSprite(getSpriteXml("assets/sprites/crystal_orange.png", "crystal_orange", 0, 32, 256, 32, 32, 0, 0));	
			loadSprite(getSpriteXml("assets/sprites/crystal_pink.png", "crystal_pink", 0, 32, 256, 32, 32, 0, 0));
			loadSprite(getSpriteXml("assets/sprites/crystal_yellow.png", "crystal_yellow", 0, 32, 256, 32, 32, 0, 0));
			loadSprite(getSpriteXml("assets/sprites/crystal_grey.png", "crystal_grey", 0, 32, 256, 32, 32, 0, 0));	
			_assetManager.enqueue("assets/sprites/flame.png");
			_assetManager.loadQueue(function(ratio:int):void{if(ratio==1)dispatchEventWith(Event.COMPLETE);});
		}
		
		public static function get():SpriteManager {
			if (_instance == null) 
				_instance = new SpriteManager(new Singleton());
			return _instance;
		}
		
		public function getDoodad(name:String, x:int, y:int):MovieClip {
			var textures:Vector.<Texture> = this._assetManager.getTextures(name);
			if (textures.length == 0) {
				trace("No textures found for " + name);
				textures = this._assetManager.getTextures("flame");
			}
			var m:MovieClip = new MovieClip(textures);
			m.x = x;
			m.y = y;
			return m;
		}
		
		public function loadSprite(xml:XML):void {
			var imageLoader:AssetLoader = new AssetLoader(xml..@imagePath);
			imageLoader.addEventListener(Event.COMPLETE, function(evt:Event):void {
				_assetManager.addTextureAtlas(xml..@imagePath, new TextureAtlas(Texture.fromBitmap(evt.data as flash.display.Bitmap), xml));
					imageLoader.removeEventListeners();
			});
			imageLoader.load();
		}
		
		public static function getSpriteXml(path:String, prefix:String, firstId:int, height:int, width:int, tileWidth:int, tileHeight:int, margin:int, spacing:int):XML {
			var numRows:uint = (height - margin) / (tileHeight + spacing);
			var numCols:uint = (width - margin) / (tileWidth + spacing);

			var xml:XML = <Atlas></Atlas>;
			var id:int = firstId;
			xml.appendChild(<TextureAtlas imagePath={path}></TextureAtlas>);
			
			for (var r:int = 0; r < numRows; r++) {
				for (var c:int = 0; c < numCols; c++) {
					xml.child("TextureAtlas").appendChild(<SubTexture name={prefix + "_" + id} x = {(margin + (c * (tileWidth + spacing)))} y={(margin + (r * (tileHeight + spacing))) } width={tileWidth} height={tileHeight}/>);
					id++;
				}
			}
			trace(xml);
			return XML(xml.TextureAtlas);
		}
	}
}
internal class Singleton { }