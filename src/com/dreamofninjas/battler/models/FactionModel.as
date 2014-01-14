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
			return new UnitModelBuilder("Hargal", name, "Spearman", spawn.x, spawn.y)
				.withStr(8)
				.withDex(9)
				.withInt(2)
				.withFai(2)
				.withHp(40)
				.withMp(10)
				.withMDef(5)
				.withPDef(5)
				.withCharId(id++);
	}
}
}