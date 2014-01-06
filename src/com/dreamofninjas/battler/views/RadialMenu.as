package com.dreamofninjas.battler.views
{
	import com.dreamofninjas.core.app.BaseView;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.events.Event;
	import com.dreamofninjas.core.ui.StandardButton;
	
	public class RadialMenu extends BaseView
	{
		public static const Builder:Class = RadialMenuBuilder;
		
		private var callbacksByButton:Dictionary = new Dictionary();
		private var _context:*;
		private var _properties:Object;
		private var _positions:Object = {'up': [0, -100],
															'down': [0, 100],
															'left': [-100, 0],
															'right': [100, 0]};
		/*
		* Takes a hash like properties[dirction] = {text:'', callable:Function}
		*/
		public function RadialMenu(properties:Object, context:* = null) {
			super(new Rectangle(-300,-300, 600, 600));
			_context = context;
			_properties = properties;
			this.touchable = true;
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(evt:Event):void {
			//this.pivotX = 100;
			//this.pivotY = 100;
			this.x = stage.width / 2;
			this.y = stage.height /2;
			for (var direction:String in _properties) {
				if (!direction in _positions) {
					throw new Error("Unknown direction " + direction + " passed to RadialMenu");
				}
				addChild(buildButton(_properties[direction].text, _properties[direction].callable,
					_positions[direction][0], _positions[direction][1]));
			}	
			addEventListener(Event.TRIGGERED, menuButtonClicked);
		}
		
		private function menuButtonClicked(evt:Event):void {
			if (_context != null) {
				callbacksByButton[evt.target].apply(_context);
			} else {
				callbacksByButton[evt.target].apply();
			}
		}
		
		private function buildButton(text:String, callable:Function, x:int ,y:int):StandardButton {
			var btn:StandardButton = new StandardButton(text, 120, 40);
			callbacksByButton[btn] = callable;
			btn.x = x;
			btn.y = y;
			return btn;
		}
	}
}

	
