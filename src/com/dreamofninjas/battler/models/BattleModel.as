package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.core.app.BaseModel;
	
	import io.arkeus.tiled.TiledObject;
	
	import starling.events.Event;
	import com.dreamofninjas.battler.FactionModel;

	public class BattleModel extends BaseModel
	{

		public function get currentUnit():UnitModel {
			return _currentUnit;
		}
		public function get targetUnit():UnitModel {
			return _targetUnit;
		}
		public function get units():Vector.<UnitModel> {
			return _units;
		}
		public function get mapModel():MapModel {
			return _mapModel;
		}

		public function set currentUnit(unit:UnitModel):void {
			_currentUnit = unit;
			dispatchEvent( new Event(Event.CHANGE));
		}
		public function set targetUnit(unit:UnitModel):void {
			_targetUnit = targetUnit;
			dispatchEvent( new Event(Event.CHANGE));
		}
		
		public var active:Boolean;

		private var _currentUnit:UnitModel;
		private var _targetUnit:UnitModel;

		private var unitSpeedComparator:Function = function(u1:UnitModel, u2:UnitModel):int {
			return u1.speed = u2.speed;
		}
		
		// Child Models -- Ownership??
		private var _units:Vector.<UnitModel> = new Vector.<UnitModel>();
		private var _mapModel:MapModel;
		private var _factions:Vector.<FactionModel>;

		public function BattleModel(mapModel:MapModel, factions:Vector.<FactionModel>)	{
			super();
			_mapModel = mapModel;
			_factions = factions;
			for  each(var faction:FactionModel in factions) {
				for each(var spawn:TiledObject in _mapModel.getSpawnsForFaction(faction.name)) {
					_units.push(faction.spawnUnit(spawn));
				}
			}
			if( _units.length > 0) {
				_targetUnit = _units[0];
				_units.sort(unitSpeedComparator);
				_currentUnit = _units[0];
			}
		}
		
		private var _index:int = 0; //temprorary hack until I get speed
		public function getNextUnit():UnitModel {
			_index = (_index + 1) % units.length;
			return units[_index];
		}
		
	}
}