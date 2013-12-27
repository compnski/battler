package com.dreamofninjas.battler
{
	import com.dreamofninjas.core.app.BaseModel;
	
	public class BattleModel extends BaseModel
	{
		
		public function get currentUnit():UnitModel {
			return _currentUnit;
		}
		public function get targetUnit():UnitModel {
			return _targetUnit;
		}
		
		public var active:Boolean;
		
		private var _currentUnit:UnitModel;
		private var _targetUnit:UnitModel;
		
		// Child Models -- Ownership??
		private var _units:Vector.<UnitModel> = new Vector.<UnitModel>();
		private var _mapModel:MapModel;
		private var _playerModel:PlayerModel;
		private var _factions:Vector.<FactionModel>;
		
		public function BattleModel(mapModel:MapModel, playerModel:PlayerModel, factions:Vector.<FactionModel>)	{
			super();
			_playerModel = playerModel;
			_mapModel = mapModel;
			_factions = factions;
		}	
	}
}
