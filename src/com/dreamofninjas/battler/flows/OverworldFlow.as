package com.dreamofninjas.battler.flows
{
	import com.dreamofninjas.battler.models.LevelModel;
	import com.dreamofninjas.battler.views.OverworldView;
	import com.dreamofninjas.core.app.BaseFlow;
	import com.dreamofninjas.core.app.BaseView;
	
	import starling.events.KeyboardEvent;
	
	public class OverworldFlow extends BaseFlow
	{
		private var _baseView:BaseView;
		private var _level:LevelModel;
		private var _overworldView:OverworldView;
		
		public function OverworldFlow(level:LevelModel, parentView:BaseView)
		{
			super();
			this._level = level;
			this._baseView = parentView;
		}
		
		public override function Execute():void {
			super.Execute();
			_overworldView = new OverworldView(this._level);
			_overworldView.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			_overworldView.addEventListener(KeyboardEvent.KEY_UP, keyUp);

			this._baseView.addChild(_overworldView);	
			_baseView.sortChildren(function(a:BaseView, b:BaseView):int {
				return a.z - b.z;
			});

		}
		
		
		private function keyUp(evt:KeyboardEvent):void {
			trace("up", evt)
		}
		
		private function keyDown(evt:KeyboardEvent):void {
			trace("down",evt)
		}

	}
}