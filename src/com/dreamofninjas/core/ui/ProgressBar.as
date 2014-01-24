package com.dreamofninjas.core.ui
{
	import com.dreamofninjas.core.app.BaseModel;
	import com.dreamofninjas.core.app.BaseView;
	
	import flash.geom.Rectangle;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;

	
	public class ProgressBar extends BaseView {

		private var _maxValue:int;
		private var _value:int;
		private var q:Quad;
		private var valueFunction:Function;
		private var statusText:TextField = new TextField(50, 30, "", "Arial", 14);
			
		public function set maxValue(v:uint):void {
			if (_maxValue != v) {
				_maxValue = v;
				updateView();
			}
		}
		
		public function set value(v:uint):void {
			if (_value != v) {
				_value = v;
				updateView();
			}
		}
		
		public function reset(v:int, maxV:int):void {
			this._value = v;
			this._maxValue = maxV;
			updateView();
		}
		
		
		public function get value():uint {
			return this._value;
		}
		
		public function ProgressBar(clipRect:Rectangle, color:uint, maxValue:int, initialValue:int=0) {
			super(clipRect);
				
			this._maxValue = maxValue;
		this._value = initialValue;
			this.q = new Quad(clipRect.width, clipRect.height, color);
			this.statusText.y = 2;
			this.statusText.x = 10;
			this.statusText.color = 0xEDDBD4;
			addChild(this.q);
			addChild(this.statusText);
			updateView();
		}
		
		public function bind(model:BaseModel, valueFunction:Function):void {
			this.valueFunction = valueFunction;
			model.removeEventListener(Event.CHANGE, modelUpdated);
			model.addEventListener(Event.CHANGE, modelUpdated);
		}
		
		private function modelUpdated(evt:Event):void {
			var val:int = this.valueFunction();
			if (val != this._value) {
				this.value = val;
			}
		}
		//Bind scrollbar to object / var?
		//watch model for update, call function to get value
		
		private function updateView():void {
			trace("updateview", this._value, this._maxValue)
			this.statusText.text = this._value + " / " + this._maxValue;
			this.q.width = this.clipRect.width * (this._value / this._maxValue);
			
		}		
	}
}