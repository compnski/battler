package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.battler.events.UnitEvent;
	import com.dreamofninjas.core.app.BaseModel;
	
	import io.arkeus.tiled.TiledObject;
	
	import starling.events.Event;

	public class BattleModel extends BaseModel
	{
		public static const CURRENT_UNIT:String = "currentUnit";
		public static const TARGET_UNIT:String = "targetUnit";
				
		public function get currentUnit():UnitModel {
			return _currentUnit;
		}
		public function get targetUnit():UnitModel {
			return _targetUnit;
		}
		public function get units():Vector.<UnitModel> {
			return mapModel.units;
		}
		public function get mapModel():MapModel {
			return _mapModel;
		}

		public function set currentUnit(unit:UnitModel):void {
			if (_currentUnit != unit) {
				_currentUnit = unit;
				dispatchEvent( new Event(Event.CHANGE, false, CURRENT_UNIT));
			}
		}
		
		public function set targetUnit(unit:UnitModel):void {
			if (_targetUnit != unit) { 
				_targetUnit = unit;
				dispatchEvent( new Event(Event.CHANGE, false, TARGET_UNIT));
			}
		}
		
		public var active:Boolean;

		private var _currentUnit:UnitModel;
		private var _targetUnit:UnitModel;

		private var unitSpeedComparator:Function = function(u1:UnitModel, u2:UnitModel):int {
			return u1.Dex - u2.Dex;
		}
		
		private var _mapModel:MapModel;
		private var _factions:Vector.<FactionModel>;

		public function BattleModel(mapModel:MapModel, factions:Vector.<FactionModel>)	{
			super();
			_mapModel = mapModel;
			_factions = factions;
			for  each(var faction:FactionModel in factions) {
				for each(var spawn:TiledObject in _mapModel.getSpawnsForFaction(faction.name)) {
					var unit:UnitModel = faction.spawnUnit(spawn);
					mapModel.addUnit(unit);
				}
			}
		}
		
		private var _index:int = 0; //temprorary hack until I get speed
		public function getNextUnit():UnitModel {
			_index = (_index + 1) % units.length;
			return units[_index];
		}
		
	}
}
