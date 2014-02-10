package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.battler.levels.UnitSpawnInfo;
	import com.dreamofninjas.core.app.BaseModel;

	/*
	*	Reads faction from properties, eventually read name/type — do lookup from there. Optionally override.
	* Delayed spawns, etc.
	*/

	public class FactionModel extends BaseModel
	{
		private var id:int = 0;
		private var _name:String;
		public function get name():String {
			return _name;
		}
		public function FactionModel(name:String)	{
			super();
			_name = name;
		}

		public function spawnUnit(spawn:UnitSpawnInfo):UnitModel {
			throw new Error("NYI");
		}
		//	return getBaseUnit(spawn).build()
		}
}