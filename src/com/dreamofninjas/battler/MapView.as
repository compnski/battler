package com.dreamofninjas.battler
{
	
	import com.dreamofninjas.core.app.BaseView;
	
	import flash.geom.Rectangle;
	
	import starling.display.BlendMode;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;

	public class MapView extends BaseView
	{
		protected var _tileWidth:int = 32;
		protected var _tileHeight:int = 32;

		protected var _tileLayer:Sprite = new Sprite();
		protected var _gridLayer:QuadBatch = new QuadBatch();
		protected var _unitLayer:Sprite = new Sprite();
		//protected var _uiLayer:Sprite = new Sprite();
		
		protected var _item:MapModel;
		
		public function MapView(clipRect:Rectangle, mapModel:MapModel) {
			super(clipRect);
			_item = mapModel;
			this.width = _item.cols * _tileWidth;
			this.height = _item.rows * _tileHeight;
			this.scaleX = 1.5;
			this.scaleY = 1.5;
			
			drawTiles();
			addChild(_tileLayer);

			drawGrid();

			addChild(_gridLayer);
			addChild(_unitLayer);
		}
		
		private function drawTiles():void {
			for (var r:uint = 0; r < _item.rows; r++) {
				for (var c:uint = 0; c < _item.cols; c++) {
					var tileId:int = _item.terrainData[r][c];
					var tile:Tile = new Tile(tileId, _assetManager.getTexture("tile_" + tileId));
					tile.x = c * tile.width;
					tile.y = r * tile.height;
					_tileLayer.addChild(tile);
				}
			}
			_tileLayer.flatten();
		}
		
		public function init():void {
			
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
		
		public function drawGrid():void {
			var q:Quad;
			var gridLines:QuadBatch = new QuadBatch();
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