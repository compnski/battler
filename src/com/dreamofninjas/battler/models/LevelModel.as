package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.battler.events.LevelEvent;
	import com.dreamofninjas.battler.levels.LevelProperties;
	import com.dreamofninjas.battler.levels.UnitSpawnInfo;
	import com.dreamofninjas.core.app.BaseModel;
	
	import flash.utils.Dictionary;
	
	import io.arkeus.tiled.TiledObject;

	public class LevelModel extends BaseModel
	{
		// battle or overworld
		public function get worldType():String {
			return this._worldType;
		}
		
		public static const BATTLE:String = "battle";
		public static const OVERWORLD:String = "overworld";
		
		// Map of types to UnitModelBuilder
		private var _unitMap:Object;
		// Map of group name to Vector.<UnitModel>
		private var groupMap:Dictionary = new Dictionary();
		public var mapModel:MapModel;
		// Map of objects from their type to a vector of contents;
		private var _typeMap:Dictionary = new Dictionary();
		
		private var _worldType:String;
		
		private var groupList:Vector.<TiledObject>;
		public function LevelModel(worldType:String, typeMap:Dictionary, mapModel:MapModel)
		{
			this._worldType = worldType;
			this.mapModel = mapModel;
			this._typeMap = typeMap;
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

			for each(var trigger:TiledObject in this._typeMap["Trigger"]) {
				if (trigger.contains(unit)) {
					switch (trigger.properties["trigger_type"]) {
						case "ai_activate":
							aiActivateTrigger(trigger);
							break;
						case "load_map":
							dispatchEventWith(LevelEvent.LOAD_MAP, true, trigger.properties['map_name'])
						break;
						case "exit":
							dispatchEventWith(LevelEvent.EXIT_MAP, true);	
						break;
					}
				}
			}
		}
		
		private function aiActivateTrigger(trigger:TiledObject):void {
			var groups:Vector.<String> = new Vector.<String>();
			trigger.properties.addToVector(LevelProperties.GROUP , groups);
			for each(var group:String in groups) {
				for each(var aiunit:AiUnitModel in groupMap[group]) {
					if (!aiunit.active) {
						trace("Waking up " + aiunit.toString());
						aiunit.activate(true);
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