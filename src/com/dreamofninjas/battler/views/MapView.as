package com.dreamofninjas.battler.views
{
	
	import com.dreamofninjas.battler.events.TileEvent;
	import com.dreamofninjas.battler.events.UnitEvent;
	import com.dreamofninjas.battler.models.MapModel;
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.core.app.BaseView;
	import com.dreamofninjas.core.ui.DisplayFactory;
	import com.dreamofninjas.core.ui.GPoint;
	import com.dreamofninjas.core.ui.TileView;
	import com.dreamofninjas.core.ui.UiUtils;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.animation.Tween;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	public class MapView extends BaseView
	{
		protected var _tileWidth:int = 32;
		protected var _tileHeight:int = 32;

		protected var _tileLayer:Sprite = DisplayFactory.getSprite();
		protected var _gridLayer:QuadBatch = DisplayFactory.getQuadBatch();
		protected var _overlayLayer:Sprite = DisplayFactory.getSprite();
		protected var _unitLayer:Sprite = DisplayFactory.getSprite();
		protected var _doodadLayer:Sprite = DisplayFactory.getSprite();
		
		private static const OVERLAY_ATTACK:String = "ATTACK";
		private static const OVERLAY_MOVE:String = "MOVE";
		private static const MOVE_OVERLAY_COLOR:uint = 0x5566ee;
		
		protected var _mapModel:MapModel;
		private var unitModelToView:Dictionary = new Dictionary(true);
		private var _assetManager:AssetManager;
		//private var _level:LevelModel;
		
		public function MapView(clipRect:Rectangle, mapModel:MapModel, assetManager:AssetManager, showGrid=false) {
			super(clipRect);
			_assetManager = assetManager;
			_mapModel = mapModel;
			this.touchable = true;
			_tileLayer.touchable = true;
			this.width = _mapModel.cols * _tileWidth;
			this.height = _mapModel.rows * _tileHeight;
			
			this.scaleX = 1.4;
			this.scaleY = 1.4;
			
			for each(var unit:UnitModel in _mapModel.units) {
				var unitView:UnitView = new UnitView(unit);
				addUnit(unit, unitView);
			}

			drawTiles();
			if(showGrid) {
				drawGrid();
			}
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
	
			addChild(_tileLayer);
			//if(_gridLayer.numQuads == 0) {

		//}
			
			addChild(_gridLayer);
			addChild(_overlayLayer);
			addChild(_unitLayer);
			addChild(_doodadLayer);
			
			addEventListener(Event.TRIGGERED, onTileClicked);
		}	
		
		private function removedFromStage(evt:Event):void {
			
			
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
		var texture:RenderTexture = new RenderTexture(32, 32, false);

		trace("drawTiles:" ,_mapModel.rows, _mapModel.cols, _mapModel.terrainData.length);
			for (var r:uint = 0; r < _mapModel.rows; r++) {
				for (var c:uint = 0; c < _mapModel.cols; c++) {
					for (var layerIdx:int = 0 ; layerIdx < _mapModel.terrainData.length; layerIdx++) {
						var tileId:int = _mapModel.terrainData[layerIdx][r][c];
						if (tileId == 0) {
							continue;
						}
						texture.draw(new Image(_assetManager.getTexture("tile_" + tileId)));
					}
					var tile:TileView = new TileView(r, c, Texture.fromBitmapData(UiUtils.copyToBitmap(new Image(texture))))
					tile.x = c * tile.width;
					tile.y = r * tile.height;
					_tileLayer.addChild(tile);
					texture.clear();
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
			
			if (obj is GPoint) {
				obj = {x: _tileWidth * obj.c,
							 y: _tileHeight * obj.r,
							 width: _tileWidth,
							 height: _tileHeight
				};
			}
			
			cx = obj.x + obj.width / 2;
			cy = obj.y + obj.height / 2;

			// Center based on scaled clipRect			
			cx = (clipRect.width / scaleX / 2) - cx;
			cy = (clipRect.height / scaleY / 2) - cy;			

			trace(cy, -(_tileLayer.height - (clipRect.height / scaleY)), _tileLayer.height, clipRect.height, scaleY);
			// Bound to make sure we always cover the viewbox 100%
			cx = Math.min(0, Math.max(cx, -(_tileLayer.width - ((-32+clipRect.width) / scaleX))));
			cy = Math.min(0, Math.max(cy, -(_tileLayer.height - ((-32+clipRect.height) / scaleY))));
			
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
			_gridLayer.blendMode = BlendMode.MULTIPLY;
			_gridLayer.alpha = 0.3;
			var numR:int = _mapModel.rows
			var numC:int = _mapModel.cols
			var h:int = _mapModel.rows * _tileHeight;
			var w:int = _mapModel.cols * _tileWidth;
			for (var r:int = -1; r <= numR; r++) {
				q = new Quad(w, 1, 0xCFCFE3);
				q.y = r * _tileHeight;
				_gridLayer.addQuad(q);
			}
			for (var c:int = -1; c <= numC; c++) {
				q = new Quad(1, h, 0xCFCFE3);
				q.x = c * _tileWidth;
				_gridLayer.addQuad(q);
			}
		}
		
		public function addDoodads(doodads:Vector.<MovieClip>):void {
			for each(var doodad:MovieClip in doodads) {
				this.juggler.add(doodad);
				this._doodadLayer.addChild(doodad);
			}
		}	
	}
}