package com.dreamofninjas.battler
{
	import com.dreamofninjas.core.app.BaseModel;
	
	import io.arkeus.tiled.TiledObject;
	
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
		
		public var active:Boolean;
		
		private var _currentUnit:UnitModel;
		private var _targetUnit:UnitModel;
		
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
			}
		}	
	}
}
