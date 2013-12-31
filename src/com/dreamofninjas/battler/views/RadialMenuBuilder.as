package com.dreamofninjas.battler.views
{
	public class RadialMenuBuilder {
		public function RadialMenuBuilder() {		}
		private var _properties:Object = new Object();
		
		public function withUp(text:String, callable:Function):RadialMenuBuilder { 
			_properties['up'] = {text:text, callable:callable};
			return this;
		}
		
		public function withDown(text:String, callable:Function):RadialMenuBuilder { 
			_properties['down'] = {text:text, callable:callable};
			return this;
		}
		public function withLeft(text:String, callable:Function):RadialMenuBuilder { 
			_properties['left'] = {text:text, callable:callable};
			return this;
		}
		public function withRight(text:String, callable:Function):RadialMenuBuilder { 
			_properties['right'] = {text:text, callable:callable};
			return this;
		}
		public function build():RadialMenu {
			return new RadialMenu(_properties);
		}
	}	
	
}