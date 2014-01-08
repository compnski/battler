package com.dreamofninjas.core.ui
{
	public class GPoint
	{
		
		private var _r:int;
		private var _c:int;
		
		private static var _points:Object = {};
		
		public function get r():int {
			return this._r;
		}
		public function get c():int {
			return this._c;
		}
			
		public static function g(r:int=0, c:int=0):GPoint {
			var key:String = r + ":" + c;
			if (_points[key] == null) {
				_points[key] = new GPoint(new NoCreateSentinel(), r, c); 
			}
			return _points[key];
		}
		
		public function GPoint(s:NoCreateSentinel, r:int=0, c:int=0)
		{
			this._r = r;
			this._c = c;
		}
		
		public function up():GPoint {
			return GPoint.g(_r - 1, c);
		}
		public function down():GPoint {
			return GPoint.g(_r + 1, c);
		}
		public function right():GPoint {
			return GPoint.g(_r, c + 1);
		}
		public function left():GPoint {
			return GPoint.g(_r , c - 1);
		}
		
		public function equals(other:GPoint):Boolean {
			return (other.r == this.r && other.c == this.c);
		}
		
		public function toString():String {
			return "[" + r + "][" + c + "]";
		}
	}
}
internal class NoCreateSentinel { }
