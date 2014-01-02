package com.dreamofninjas.core.ui
{
	import starling.display.QuadBatch;
	import starling.display.Sprite;

	public class DisplayFactory
	{
		public function DisplayFactory()
		{
		}
		
		public static function getQuadBatch():QuadBatch {
			var q:QuadBatch = new QuadBatch();
			q.touchable = false;
			return q;
		}
		
		public static function getSprite():Sprite {
			var s:Sprite = new Sprite();
			s.touchable = false;
			return s;
		}
	}
}