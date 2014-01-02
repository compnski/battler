package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.core.app.BaseModel;

	import io.arkeus.tiled.TiledObject;

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

		public function spawnUnit(spawn:TiledObject):UnitModel {
			return getBaseUnit(spawn).build()
		}

		public function getBaseUnit(spawn:TiledObject):UnitModelBuilder {
			return (new UnitModel.Builder)(name, "Spearman", spawn.x, spawn.y)
				.withAtk(8)
				.withDef(9)
				.withHp(40)
				.withMp(10)
				.withSpd(30)
				.withCharId(id++);
	}
}
}