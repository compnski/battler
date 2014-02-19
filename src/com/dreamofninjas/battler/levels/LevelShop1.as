package com.dreamofninjas.battler.levels
{
	import com.dreamofninjas.battler.models.LevelModel;
	import com.dreamofninjas.battler.models.MapModel;
	import com.dreamofninjas.battler.models.PlayerModel;
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.battler.models.UnitModelBuilder;
	
	import flash.utils.Dictionary;
	
	public class LevelShop1 extends LevelModel {

		public static const MAP_FILE:String = "shop1.tmx";
		
		public static function Loader(playerModel:PlayerModel):LevelLoader {
			return new LevelLoader(MAP_FILE, LevelShop1, playerModel);
		}
		
		private var unitMap:Object= {
			"Neculai" : new UnitModelBuilder()
	 	  .withFaction("Ally").withType("Shopkeeper")
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
			
		public function LevelShop1(playerModel:PlayerModel, mapModel:MapModel, typeMap:Dictionary, spawns:Vector.<UnitSpawnInfo>) {
			super(LevelModel.OVERWORLD, typeMap, mapModel)
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