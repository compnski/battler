package com.dreamofninjas.battler.flows
{
	import com.dreamofninjas.battler.events.LevelEvent;
	import com.dreamofninjas.battler.events.TileEvent;
	import com.dreamofninjas.battler.models.LevelModel;
	import com.dreamofninjas.battler.models.PlayerModel;
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.battler.util.BattlerPathUtils;
	import com.dreamofninjas.battler.views.OverworldView;
	import com.dreamofninjas.core.app.BaseFlow;
	import com.dreamofninjas.core.app.BaseView;
	import com.dreamofninjas.core.engine.PathUtils;
	import com.dreamofninjas.core.ui.GPoint;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	public class OverworldFlow extends BaseFlow
	{
		private var _baseView:BaseView;
		private var _level:LevelModel;
		private var _overworldView:OverworldView;
		private var _mainUnit:UnitModel; 
		private var floodMap:Object;
		private var _playerModel:PlayerModel;
		
		
		public function OverworldFlow(playerModel:PlayerModel, level:LevelModel, parentView:BaseView)
		{
			super();
			this._playerModel = playerModel;
			this._level = level;
			this._baseView = parentView;
			for each(var unit:UnitModel in level.mapModel.units) {
				if (unit.faction == "Player") {
					_mainUnit = unit;
					break;
				}
			}
			if (_mainUnit == null) {
				throw new Error("No player unit found in overworld");
			}
		}
		
		public override function Execute():void {
			super.Execute();
			
			floodMap = PathUtils.floodFill(GPoint.g(_mainUnit.r, _mainUnit.c), BattlerPathUtils.getStdPathCostFunction(_mainUnit, _level.mapModel), 20);

			
			_overworldView = new OverworldView(this._level);
			_overworldView.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			_overworldView.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			_overworldView.addEventListener(TileEvent.CLICKED, tileClicked);
			
			_level.addEventListener(LevelEvent.LOAD_MAP, loadMap);
			_level.addEventListener(LevelEvent.EXIT_MAP, Complete);
		
			this._baseView.addChild(_overworldView);	
			_baseView.sortChildren(function(a:BaseView, b:BaseView):int {
				return a.z - b.z;
			});		
			
		}

		private function loadMap(evt:Event):void {
			setNextFlow(new LoadLevelFlow(_baseView, _playerModel, evt.data as String));
		}
		
		private function tileClicked(evt:TileEvent):void {
			trace("click")
			if (!active) {
				return;
			}
			var dest:GPoint = evt.data as GPoint;
			var start:GPoint = GPoint.g(_mainUnit.r, _mainUnit.c);

			if (start.equals(dest)) {
				return;
			}
			
			if (!(dest in floodMap) ||!floodMap[dest].reachable) { 
				return;
			}
			
			var path:Array = PathUtils.getPath(floodMap, start, dest);
			trace(path)
			setNextFlow(new MoveUnitFlow(_overworldView._mapView.getUnit(_mainUnit), path, Starling.juggler));
		}
		
		public override function Suspended():void {
			super.Suspended();
		}

		public override function Restored(evt:Event):void {
			super.Restored(evt);
			if (evt.target is MoveUnitFlow) {
				// :[
				_mainUnit.r = (evt.target as MoveUnitFlow).dest.r;
				_mainUnit.c = (evt.target as MoveUnitFlow).dest.c;
				floodMap = PathUtils.floodFill(GPoint.g(_mainUnit.r, _mainUnit.c), BattlerPathUtils.getStdPathCostFunction(_mainUnit, _level.mapModel), 20);
				_level.afterUnitTurn(_mainUnit);
			}
		}

		
		private function keyUp(evt:KeyboardEvent):void {
			//trace("up", evt)
			//MOVE PLAYER 
		}
		
		private function keyDown(evt:KeyboardEvent):void {
			//trace("down",evt)
			//move player
		}

	}
}