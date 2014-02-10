package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.battler.levels.LevelProperties;
	import com.dreamofninjas.battler.levels.UnitSpawnInfo;
	import com.dreamofninjas.core.app.BaseModel;
	
	import flash.utils.Dictionary;
	
	import io.arkeus.tiled.TiledObject;

	public class LevelModel extends BaseModel
	{
		// Map of types to UnitModelBuilder
		private var _unitMap:Object;
		// Map of group name to Vector.<UnitModel>
		private var groupMap:Dictionary = new Dictionary();
		public var mapModel:MapModel;
		// Map of objects from their type to a vector of contents;
		private var _typeMap:Dictionary = new Dictionary();
		public var battleModel:BattleModel;
		
		private var groupList:Vector.<TiledObject>;
//TODO: Split into LevelLoader and LevelModel
		public function LevelModel(typeMap:Dictionary, mapModel:MapModel, battleModel:BattleModel)
		{
			this.mapModel = mapModel;
			this._typeMap = typeMap;
			this.battleModel = battleModel;
		}

		private function getPlayerUnit(spawn:TiledObject):UnitModel {
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
				.withMove(6)
				.withMDef(10)
//				.withCharId(id++)
				.build(AiUnitModel);
				if (u is AiUnitModel) {
					(u as AiUnitModel).active = true;
				}
			return u;
		}

		protected function registerUnitMap(obj:Object):void {
			this._unitMap = obj;
		}

		public function beforeBattleStart():void {
		}

		public function beforeUnitTurn(unit:UnitModel):void {

		}

		public function afterUnitTurn(unit:UnitModel):void {
			if (unit.faction != "Player") {
				return;
			}
			var groups:Vector.<String> = new Vector.<String>();
			for each(var trigger:TiledObject in this._typeMap["Trigger"]) {
				if (trigger.contains(unit)) {
					trigger.properties.addToVector(LevelProperties.GROUP , groups);
				}
			}
			for each(var group:String in groups) {
				for each(var aiunit:AiUnitModel in groupMap[group]) {
					if (!aiunit.active) {
						trace("Waking up " + aiunit.toString());
						aiunit.activate(true);
						this.battleModel.queueNewTurnAction(aiunit, randint(1, 20));
					}
				}
			}
		}
		
		public function spawnAiUnit(spawnInfo:UnitSpawnInfo):UnitModel {
			var unitBuilder:UnitModelBuilder;
			if (spawnInfo.name && spawnInfo.name in _unitMap) {
				unitBuilder = _unitMap[spawnInfo.name]
			} else if (spawnInfo.type && spawnInfo.type in _unitMap) {
				unitBuilder = _unitMap[spawnInfo.type].withName(generateRandomName())
			}				
			unitBuilder.withX(spawnInfo.x)
					.withY(spawnInfo.y)
					.withFaction(spawnInfo.faction)
			
			var unit:AiUnitModel = unitBuilder.build(AiUnitModel) as AiUnitModel;

			// Add to group lists
			for each(var group:String in spawnInfo.groups) {
				if (!(group in groupMap)) {
					groupMap[group] = new Vector.<UnitModel>();
				}
				var unitList:Vector.<UnitModel> = groupMap[group];
				unitList.push(unit);
			}
			unit.active = spawnInfo.active;
			unit.groups = spawnInfo.groups;					
			return unit;
		}

		protected function generateRandomName():String {
			return "Pokey";
		}			
	}
}