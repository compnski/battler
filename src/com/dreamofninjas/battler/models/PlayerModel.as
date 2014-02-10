package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.battler.levels.UnitSpawnInfo;

	public class PlayerModel extends FactionModel
	{
		private var id:int = 0;
		
		public function PlayerModel() {
			super("Player");
		}
		
		public override function spawnUnit(spawn:UnitSpawnInfo):UnitModel {
			var u:UnitModel = new UnitModel.Builder()
				.withName("Jason")
				.withFaction("Player")
				.withType("Swordman")
				.withX(spawn.x)
				.withY(spawn.y)
				.withStr(10)
				.withDex(10)
				.withInt(10)
				.withFai(10)				
				.withHp(50)
				.withMp(20)
				.withPDef(11)
				.withMDef(10)
				.withMove(6)
				.withCharId(id++)
				.build();

//			u.getEffects().push(new StatAffectingStatusEffect(StatType.HP, 10));
			return u;
		}
		
	}
}