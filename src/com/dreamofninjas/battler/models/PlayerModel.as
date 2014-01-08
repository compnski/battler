package com.dreamofninjas.battler.models
{
	import io.arkeus.tiled.TiledObject;

	public class PlayerModel extends FactionModel
	{
		private var id:int = 0;
		
		public function PlayerModel() {
			super("Player");
		}
		
		public override function spawnUnit(spawn:TiledObject):UnitModel {
			return ((new UnitModel.Builder)("Player", "Swordman", spawn.x, spawn.y)
				.withStr(10)
				.withDex(10)
				.withInt(10)
				.withFai(10)				
				.withHp(50)
				.withMp(20)
				.withPDef(10)
				.withMDef(10)
				.withSpd(30)
				.withCharId(id++)
				.build());
		}
		
	}
}