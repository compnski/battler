package com.dreamofninjas.battler
{
	import com.dreamofninjas.battler.flows.InitialFlow;
	import com.dreamofninjas.battler.flows.LoadLevelFlow;
	import com.dreamofninjas.battler.models.BattleModel;
	import com.dreamofninjas.battler.models.PlayerModel;
	import com.dreamofninjas.core.app.BaseView;
	import com.dreamofninjas.core.util.MultiLoader;
	
	import flash.geom.Rectangle;
	
	import starling.display.Quad;
	import starling.events.Event;

	public class BattlerStage extends BaseView {
		protected var initialAssetLoader:MultiLoader = new MultiLoader();
		private var q:Quad;
				
		private var _timerController:*;
		private var _timerView:BaseView;
				
		private var _item:BattleModel;
		
		public function BattlerStage()
		{
			super(new Rectangle(0, 0, 1280, 720));
			this.y = 50;
			this.touchable = true;
			trace("BattlerStage");
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(evt:Event):void 
		{
			this.width = 1280;
			this.height = 720;
			var playerModel:PlayerModel = new PlayerModel();

			new InitialFlow(new LoadLevelFlow(this, playerModel, "overworld"));
		}
	}
}
