package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.battler.levels.UnitSpawnInfo;

	public class PlayerModel extends FactionModel
	{
		private var id:int = 0;
		public var squad:Vector.<CharacterModel> = new Vector.<CharacterModel>();
		
		public function PlayerModel() {
			super("Player");
			
			squad.push(CharacterModel.LoadFromJsonObj({"name": "Jason", "job":"Slasher", "xp":"131",
				"str": 10, "dex": 12, "int": "14", "fai": 9, "att": 2, "move": 6, "items": [{
					"properties": {"int": 10}
				}]
			}));
		}

		public static function LoadFromJsonObj(obj:Object):PlayerModel {
			var p:PlayerModel = new PlayerModel();
			for each(var charObj:Object in obj["characters"]) {
				p.squad.push(CharacterModel.LoadFromJsonObj(charObj));
			}
			return p;
		}

		public override function spawnUnit(spawn:UnitSpawnInfo):UnitModel {
			// faction should be Player, name should be string version of an int, from 1-lastUnit
			var spawnId:int = int(spawn.name) - 1;
			if (spawnId < 0) {
				throw new Error("Got bad player spawn. name=" + spawn.name);
			}
			if (spawnId >= this.squad.length) {
				return null;
			}
			var u:UnitModel = squad[spawnId].getUnitBuilder().withX(spawn.x).withY(spawn.y).build();
			return u;
		}
		
	}
}