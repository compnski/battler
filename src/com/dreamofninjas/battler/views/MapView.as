package com.dreamofninjas.battler.views
{
	
	import com.dreamofninjas.battler.events.TileEvent;
	import com.dreamofninjas.battler.models.MapModel;
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.core.app.BaseView;
	import com.dreamofninjas.core.ui.DisplayFactory;
	import com.dreamofninjas.core.ui.GPoint;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.animation.Tween;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;

	public class MapView extends BaseView
	{
		protected var _tileWidth:int = 32;
		protected var _tileHeight:int = 32;

		protected var _tileLayer:Sprite = DisplayFactory.getSprite();
		protected var _gridLayer:QuadBatch = DisplayFactory.getQuadBatch();
		protected var _overlayLayer:Sprite = DisplayFactory.getSprite();
		protected var _unitLayer:Sprite = DisplayFactory.getSprite();
		//protected var _uiLayer:Sprite = new Sprite();
		
		private static const OVERLAY_ATTACK:String = "ATTACK";
		private static const OVERLAY_MOVE:String = "MOVE";
		private static const MOVE_OVERLAY_COLOR:uint = 0x5566ee;
		
		protected var _item:MapModel;
		
		public function MapView(clipRect:Rectangle, mapModel:MapModel) {
			super(clipRect);
			_item = mapModel;
			this.touchable = true;
			_tileLayer.touchable = true;
			this.width = _item.cols * _tileWidth;
			this.height = _item.rows * _tileHeight;
			
			this.scaleX = 1.4;
			this.scaleY = 1.4;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(evt:Event):void {
			
			drawTiles();
			addChild(_tileLayer);
			
			drawGrid();
			
			addChild(_gridLayer);
			addChild(_overlayLayer);
			addChild(_unitLayer);
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(evt:TouchEvent): void {
			var t:Touch = evt.getTouch(this);
			if (t && t.tapCount > 0) {
				var loc:Point = t.getLocation(this);
				trace(["touch", evt.target, loc]);
				var unitSprite:DisplayObject = _unitLayer.hitTest(loc);
				var overlay:DisplayObject = _overlayLayer.hitTest(loc);
				if (overlay is QuadBatch) {
					overlay = overlay.hitTest(loc);
				}
				//TOOD: Signal if it hit something interesting like a unit
				trace(unitSprite, overlay);
				//new Point(loc.x, loc.y))
				var r:int = Math.floor((loc.y - _tileLayer.y) / _tileHeight);
				var c:int = Math.floor((loc.x - _tileLayer.x) / _tileWidth);

				dispatchEvent(new TileEvent(TileEvent.CLICKED, true, new GPoint(r, c)));
			}
		}			
			
		public function addUnit(unit:Sprite):void {
			_unitLayer.addChild(unit);
		}
		
		public function drawOverlay(tiles:Array,centerR:int=0, centerC:int=0):DisplayObject {
			var overlayBatch:QuadBatch = DisplayFactory.getQuadBatch();
			overlayBatch.x = centerC * 32;
			overlayBatch.y = centerR * 32;
			for each(var tile:Object in tiles) {
				var q:Quad = new Quad(32, 32, MOVE_OVERLAY_COLOR);
			//q.touchable = true;
				q.x = (tile.c - centerR) * 32;
				q.y = (tile.r - centerC) * 32;
				overlayBatch.addQuad(q);
			}
			overlayBatch.alpha = 0.3;
			const FADE_TIME:Number = 1.0;
			var fadeOverlay:Tween = new Tween(overlayBatch, FADE_TIME, "easeOut");
			fadeOverlay.repeatDelay = 0;
			fadeOverlay.reverse = true;
			fadeOverlay.repeatCount = 0;
			fadeOverlay.fadeTo(0.0);
			// listen to the progress t.onUpdate = onProgress; // listen to the end t.onComplete = onComplete;
			
			
			//Starling.juggler.add(fadeOverlay);
			_overlayLayer.addChild(overlayBatch);
			return overlayBatch;
		}
		
		private function drawTiles():void {
			for (var r:uint = 0; r < _item.rows; r++) {
				for (var c:uint = 0; c < _item.cols; c++) {
					var tileId:int = _item.terrainData[r][c];
					var tile:TileView = new TileView(tileId, _assetManager.getTexture("tile_" + tileId));
					tile.x = c * tile.width;
					tile.y = r * tile.height;
					_tileLayer.addChild(tile);
				}
			}
			_tileLayer.flatten();
		}
		
		public function init():void {
			
		}
		
		public function centerOn(x:int, y:int):void {
			
			trace("bounds " + [width, height, clipRect]);
			trace("scroll to " + [x , y] + " " + [x/scaleX, y/scaleY]);
			x = (clipRect.width / scaleX / 2  - x / scaleX);
			y = (clipRect.height / scaleY / 2  - y / scaleY);	
			
			var p:Point = this.localToGlobal(new Point(x, y));
			x = p.x;
			y = p.y;

			trace("global " + [x, y]);
			x = Math.min(0, Math.max(x, -(_tileLayer.width - (clipRect.width / scaleX))));
			y = Math.min(0, Math.max(y, -(_tileLayer.height - (clipRect.height / scaleY))));
			
			trace("global " + [x, y]);
			
			_scroll(_tileLayer, x, y);
			_scroll(_unitLayer, x, y);			
			_scroll(_overlayLayer, x, y);
			_scroll(_gridLayer, x, y);
		}
	
		private function _scroll(obj:DisplayObject, x:int, y:int):void {
			var move:Tween = new Tween(obj, 0.2);
			move.moveTo(x, y);
			juggler.add(move);
		}
		
		
		public function scroll(x:int, y:int):void {
			// TODO: Tween
			_tileLayer.x += x;
			_tileLayer.y += y;
			
			_unitLayer.x += x;
			_unitLayer.y += y;
						
			_gridLayer.y = (_gridLayer + y) % _tileHeight;
			_gridLayer.x = (_gridLayer + x) % _tileWidth;
		}
		
		private function drawGrid():void {
			var q:Quad;
			var gridLines:QuadBatch = DisplayFactory.getQuadBatch();
			gridLines.blendMode = BlendMode.MULTIPLY;
			gridLines.alpha = 0.3;
			var numC:int = this.height / _tileHeight + 1;
			var numR:int = this.width / _tileWidth + 1;
			for (var r:int = -1; r < numR; r++) {
				q = new Quad(this.width + _tileWidth, 1, 0xCFCFE3);
				q.y = r * _tileHeight;
				gridLines.addQuad(q);
			}
			for (var c:int = -1; c < numC; c++) {
				q = new Quad(1, this.height + _tileHeight, 0xCFCFE3);
				q.x = c * _tileWidth;
				gridLines.addQuad(q);
			}
			addChild(gridLines); 
			trace('done with grid');
		}
	}
}