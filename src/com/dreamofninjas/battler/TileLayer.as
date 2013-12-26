package com.dreamofninjas.battler
{
	import starling.display.BlendMode;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	
	public class TileLayer extends Sprite
	{
		protected var _tileWidth:int = 32;
		protected var _tileHeight:int = 32;
			
		public function TileLayer()
		{
			super();
		}
		
		public function drawGrid():void {
			var q:Quad;
			var gridLines:QuadBatch = new QuadBatch();
			gridLines.blendMode = BlendMode.MULTIPLY;
			gridLines.alpha = 0.3;
			trace('drawing grid ' + width/_tileWidth + ' ' + height/_tileHeight);
			for (var r:int = 0; r < this.height / _tileHeight; r++) {
				q = new Quad(this.width, 1, 0xCFCFE3);
				q.y = r * _tileHeight;
				gridLines.addQuad(q);
			}
			for (var c:int = 0; c < this.width / _tileWidth; c++) {
				q = new Quad(1, this.height, 0xCFCFE3);
				q.x = c * _tileWidth;
				gridLines.addQuad(q);
			}//0xCFCFE3
			addChild(gridLines); 
			trace('done with grid');
		}
	}
}