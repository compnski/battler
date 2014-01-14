package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.battler.StatAffectingStatusEffect;
	import com.dreamofninjas.battler.StatType;
	
	import io.arkeus.tiled.TiledObject;

	public class PlayerModel extends FactionModel
	{
		private var id:int = 0;
		
		public function PlayerModel() {
			super("Player");
		}
		
		public override function spawnUnit(spawn:TiledObject):UnitModel {
			var u:UnitModel = ((new UnitModel.Builder)("Jason", "Player", "Swordman", spawn.x, spawn.y)
				.withStr(10)
				.withDex(10)
				.withInt(10)
				.withFai(10)				
				.withHp(50)
				.withMp(20)
				.withPDef(11)
				.withMDef(10)
				.withCharId(id++)
				.build());

			u.getEffects().push(new StatAffectingStatusEffect(StatType.HP, 10));
			return u;
		}
		
	}
}