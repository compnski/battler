package com.dreamofninjas.battler.views
{
	
	import com.dreamofninjas.battler.events.TileEvent;
	import com.dreamofninjas.battler.events.UnitEvent;
	import com.dreamofninjas.battler.models.MapModel;
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.core.app.BaseView;
	import com.dreamofninjas.core.ui.DisplayFactory;
	import com.dreamofninjas.core.ui.GPoint;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.animation.Tween;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import com.dreamofninjas.core.ui.TileView;

	public class MapView extends BaseView
	{
		protected var _tileWidth:int = 32;
		protected var _tileHeight:int = 32;

		protected var _tileLayer:Sprite = DisplayFactory.getSprite();
		protected var _gridLayer:QuadBatch = DisplayFactory.getQuadBatch();
		protected var _overlayLayer:Sprite = DisplayFactory.getSprite();
		protected var _unitLayer:Sprite = DisplayFactory.getSprite();
		
		private static const OVERLAY_ATTACK:String = "ATTACK";
		private static const OVERLAY_MOVE:String = "MOVE";
		private static const MOVE_OVERLAY_COLOR:uint = 0x5566ee;
		
		protected var _item:MapModel;
		private var unitModelToView:Dictionary = new Dictionary(true);
		
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
		
		// CHILD VIEWS
		
		// UNITS
		public function getUnit(unit:UnitModel):UnitView {
			return unitModelToView[unit];
		}
		
		public function removeUnit(unit:UnitModel):void {
			var u:UnitView = getUnit(unit);
			if (u) {
				u.removeFromParent(true);
				delete unitModelToView[unit];
			}
		}
		 
		public function addUnit(unit:UnitModel, unitView:Sprite):void {
			_unitLayer.addChild(unitView);
			unitModelToView[unit] = unitView;
			unit.addEventListener(UnitEvent.DIED, unitDiedHandler);
		}
		
		private function unitDiedHandler(evt:Event):void {
			var unit:UnitModel = evt.target as UnitModel;
			removeUnit(unit);
		}
		
		private function addedToStage(evt:Event):void {
			
			drawTiles();
			addChild(_tileLayer);
			
			drawGrid();
			
			addChild(_gridLayer);
			addChild(_overlayLayer);
			addChild(_unitLayer);
			
			addEventListener(Event.TRIGGERED, onTileClicked);
		}	
		
		private function onTileClicked(evt:Event):void {
			var t:TileView = evt.target as TileView;
			dispatchEvent(new TileEvent(TileEvent.CLICKED, true, GPoint.g(t.r, t.c)));
			evt.stopPropagation();
		}
				
		public function drawOverlay(tiles:Object, color:uint=0x000000ee, centerR:int=0, centerC:int=0):DisplayObject {
			var overlayBatch:QuadBatch = DisplayFactory.getQuadBatch();
			overlayBatch.x = centerC * 32;
			overlayBatch.y = centerR * 32;
			for each(var tile:Object in tiles) {
				if (!tile.reachable) {
					continue;
				}
				var q:Quad = new Quad(32, 32, color);
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
					if (tileId == 0) {
						continue;
					}
					var tile:TileView = new TileView(tileId, r, c, _assetManager.getTexture("tile_" + tileId));
					tile.x = c * tile.width;
					tile.y = r * tile.height;
					_tileLayer.addChild(tile);
				}
			}
			_tileLayer.flatten();
		}
		
		public function init():void {
			
		}
		
		// Obj needs to have x,y,width,height set
		public function centerOn(obj:Object):void {
			var cx:int, cy:int;
			if (obj is UnitModel) {
				obj = getUnit(obj as UnitModel);
			}
			cx = obj.x + obj.width / 2;
			cy = obj.y + obj.height / 2;

			// Center based on scaled clipRect			
			cx = (clipRect.width / scaleX / 2) - cx;
			cy = (clipRect.height / scaleY / 2) - cy;			

			// Bound to make sure we always cover the viewbox 100%
			cx = Math.min(0, Math.max(cx, -(_tileLayer.width - (clipRect.width / scaleX))));
			cy = Math.min(0, Math.max(cy, -(_tileLayer.height - (clipRect.height / scaleY))));
			
			// Clamp to full tiles.
			cx = int(cx / _tileWidth) * _tileWidth;
			cy = int(cy / _tileHeight) * _tileHeight;

			var dest:Point = new Point(cx, cy);
			var SPEED:Number = 100; // pixels per seconed
			_scroll(_tileLayer, dest, SPEED);
			_scroll(_unitLayer, dest, SPEED);			
			_scroll(_overlayLayer, dest, SPEED);
		}
	
		private function _scroll(obj:DisplayObject, dest:Point, scrollSpeed:Number):void {
			var distance:Number = Math.abs(Point.distance(new Point(obj.x, obj.y), dest));
			var time:Number = Math.max(0.3, Math.min(0.6, distance / scrollSpeed));
			
			var move:Tween = new Tween(obj, time, "easeInOut");
			move.moveTo(dest.x, dest.y);
			juggler.add(move);
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
		}
	}
}