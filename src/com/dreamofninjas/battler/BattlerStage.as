package com.dreamofninjas.battler
{
	import com.dreamofninjas.battler.flows.BattleFlow;
	import com.dreamofninjas.battler.flows.InitialFlow;
	import com.dreamofninjas.battler.levels.Level1;
	import com.dreamofninjas.battler.models.LevelModel;
	import com.dreamofninjas.battler.models.BattleModel;
	import com.dreamofninjas.battler.models.FactionModel;
	import com.dreamofninjas.battler.models.MapModel;
	import com.dreamofninjas.battler.models.PlayerModel;
	import com.dreamofninjas.battler.views.MapView;
	import com.dreamofninjas.core.app.BaseView;
	import com.dreamofninjas.core.util.MultiLoader;
	
	import flash.geom.Rectangle;
	
	import starling.display.Quad;
	import starling.events.Event;

	public class BattlerStage extends BaseView {
		protected var initialAssetLoader:MultiLoader = new MultiLoader();
		private var q:Quad;
		
		private var _mapModel:MapModel;
		private var _mapView:MapView;
		
		private var _timerController:*;
		private var _timerView:BaseView;
		
		private var level:LevelModel = new Level1();
		
		private var _item:BattleModel;
		
		public function BattlerStage()
		{
			super(new Rectangle(0, 0, 1280, 720));
			this.y = 50;
			this.touchable = true;
			level.addEventListener(Event.COMPLETE, mapLoaded);
			trace("BattlerStage");
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(evt:Event):void 
		{
			this.width = 1280;
			this.height = 720;
			level.load();
		}

		protected function mapLoaded(evt:Event):void {
			trace("loaded!");
			var level:LevelModel = evt.target as LevelModel;
			var atlases:Object = evt.data.atlases;
			for each (var atlas:Object in atlases) {
				_assetManager.addTextureAtlas(atlas.name, atlas.textures);
			}

			var playerModel:PlayerModel = new PlayerModel();
			var factions:Vector.<FactionModel> = new Vector.<FactionModel>;
			factions.push(new FactionModel("Enemy"));
			factions.push(playerModel);

			_item = new BattleModel(level, factions);			
			level.battleModel = _item;
			
			sortChildren(function(a:BaseView, b:BaseView):int {
				return a.z - b.z;
			});
			
			var bf:BattleFlow = new BattleFlow(_item, this);
			new InitialFlow(bf);
		}
	}
}
