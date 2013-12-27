package com.dreamofninjas.battler
{
	import com.dreamofninjas.core.app.BaseModel;
	
	import io.arkeus.tiled.TiledObject;
	
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
				.withCharId(id++);
	}
}
}