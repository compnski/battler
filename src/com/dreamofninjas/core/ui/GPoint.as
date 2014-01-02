package com.dreamofninjas.core.ui
{
	public class GPoint
	{
		public var r:int;
		public var c:int;
		public function GPoint(r:int=0, c:int=0)
		{
			this.r = r;
			this.c = c;
		}
		
		public function up():GPoint {
			return new GPoint(r - 1, c);
		}
		public function down():GPoint {
			return new GPoint(r + 1, c);
		}
		public function right():GPoint {
			return new GPoint(r, c + 1);
		}
		public function left():GPoint {
			return new GPoint(r , c - 1);
		}
		
		
		public function toString():String {
			return "[" + r + "][" + c + "]";
		}
	}
}