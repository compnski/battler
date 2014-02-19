package com.dreamofninjas.battler.levels
{
	import com.dreamofninjas.battler.models.LevelModel;
	import com.dreamofninjas.battler.models.MapModel;
	import com.dreamofninjas.battler.models.PlayerModel;
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.battler.models.UnitModelBuilder;
	
	import flash.utils.Dictionary;
	
	public class Level1 extends LevelModel {

		public static const MAP_FILE:String = "test.tmx";
		
		public static function Loader(playerModel:PlayerModel):LevelLoader {
			return new LevelLoader(MAP_FILE, Level1, playerModel);
		}
		
		private var unitMap:Object= {
			"Spearman" : new UnitModelBuilder()
			.withFaction("Enemy").withType("Spearman")
			.withStr(15)
			.withDex(13)
			.withInt(6)
			.withFai(8)
			.withHp(25)
			.withMp(4)
			.withMove(6)
			.withMDef(12)
			.withPDef(15),
			"Spearwoman" : new UnitModelBuilder()
			.withFaction("Enemy").withType("Spearwoman")
			.withStr(13)
			.withDex(15)
			.withInt(6)
			.withFai(8)
			.withHp(25)
			.withMp(4)
			.withMove(6)
			.withMDef(13)
			.withPDef(14),
			"Mage" : new UnitModelBuilder()
	 	  .withFaction("Enemy").withType("Mage")
			.withStr(14)
			.withDex(14)
			.withInt(6)
			.withFai(8)
			.withHp(19)
			.withMp(4)
			.withMove(6)
			.withMDef(12)
			.withPDef(15),
			"War Baron" : new UnitModelBuilder()
	 	  .withFaction("Enemy").withType("Mage")
			.withStr(16)
			.withDex(16)
			.withInt(6)
			.withFai(8)
			.withHp(35)
			.withMp(12)
			.withMove(6)
			.withMDef(16)
			.withPDef(16)
		};
			
		public function Level1(playerModel:PlayerModel, mapModel:MapModel, typeMap:Dictionary, spawns:Vector.<UnitSpawnInfo>) {
			super(LevelModel.BATTLE, typeMap, mapModel)
			registerUnitMap(unitMap);
			for each(var spawn:UnitSpawnInfo in spawns) {
				if (spawn.faction == "Player") {
					var u:UnitModel = playerModel.spawnUnit(spawn);
					if (u) {
						mapModel.addUnit(u);
					}
				} else {
					mapModel.addUnit(this.spawnAiUnit(spawn));
				}
			}
		}
	}
}