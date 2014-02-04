package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.battler.levels.LevelObjects;
	import com.dreamofninjas.core.engine.MapLoader;
	import com.dreamofninjas.core.util.BaseLoader;
	
	import flash.utils.Dictionary;
	
	import io.arkeus.tiled.TiledLayer;
	import io.arkeus.tiled.TiledMap;
	import io.arkeus.tiled.TiledObject;
	import io.arkeus.tiled.TiledObjectLayer;
	import io.arkeus.tiled.TiledProperties;
	
	import starling.events.Event;
	import com.dreamofninjas.battler.levels.LevelProperties;

	public class LevelModel extends BaseLoader
	{
		// Map of types to UnitModelBuilder
		private var unitMap:Object;
		// Map of group name to Vector.<UnitModel>
		private var groupMap:Dictionary = new Dictionary();
		private var mapLoader:MapLoader;
		public var mapModel:MapModel;
		// Map of objects from their type to a vector of contents;
		private var _typeMap:Dictionary = new Dictionary();
		public var battleModel:BattleModel;
		
		private var groupList:Vector.<TiledObject>;
//TODO: Split into LevelLoader and LevelModel
		public function LevelModel()
		{
			this.battleModel = battleModel;
			mapLoader = new MapLoader("assets/maps/", "test.tmx");
			mapLoader.addEventListener(Event.COMPLETE, mapLoaded);
		}

		protected function mapLoaded(evt:Event):void {
			var map:TiledMap = evt.data.map;
			var atlases:Object = evt.data.atlases;
			mapModel = new MapModel(map);

			for each (var layer:TiledLayer in map.layers.getAllLayers()) {
				if (layer is TiledObjectLayer) {
					loadObjects(layer as TiledObjectLayer);
				}
			}

			for each(var spawn:TiledObject in _typeMap[LevelObjects.SPAWN]) {
				if (spawn.properties.get(LevelProperties.FACTION) == "Player") {
					mapModel.addUnit(getPlayerUnit(spawn))
				} else {
					mapModel.addUnit(getUnitForSpawn(spawn));
				}
			}
			loadComplete({atlases: atlases});
		}

		public override function load(timeout:uint=0):void {
			mapLoader.load(timeout);
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
				.build();
				if (u is AiUnitModel) {
					(u as AiUnitModel).active = true;
				}
			return u;
		}

		private function loadObjects(layer:TiledObjectLayer):void {
			for (var type:String in layer.typeMap) {
				var obj:Vector.<TiledObject> = layer.typeMap[type];
				// Apply layer properties to tile
				obj.forEach(function(item:TiledObject, index:int, vector:Vector.<TiledObject>):void {
					item.properties.extend(layer.properties);
				});

				if (_typeMap.hasOwnProperty(type)) {
					_typeMap[type] = (_typeMap[type] as Vector.<TiledObject>).concat(obj);
				} else {
					_typeMap[type] = obj;
				}
				for each(var o:TiledObject in _typeMap[type]) {
				}
			}
		}

		private function addGroupsFromObject(props:TiledProperties, groups:Vector.<String>):int {
			var initialLen:int = groups.length;
			if (props.has(LevelProperties.GROUP)) {
				groups.push(props.get(LevelProperties.GROUP));
			}
			if (props.has(LevelProperties.GROUPS)) {
				groups.concat(props.get(LevelProperties.GROUPS).split(","))
			}
			return groups.length - initialLen;
		}

		private function addGroupsFromMapGroups(unit:UnitModel, groups:Vector.<String>):int {
			var groupsAdded:int = 0;
			for each(var group:TiledObject in this._typeMap["UnitGroup"]) {
				if (group.contains(unit)) {
					groupsAdded += addGroupsFromObject(group.properties, groups);
				}
			}
			return groupsAdded;
		}

		public function getUnitForSpawn(spawn:TiledObject):UnitModel {
			var props:TiledProperties = spawn.properties;
			if (props.get(LevelProperties.FACTION) == "Player") {
				return null;
			}
			var unitBuilder:UnitModelBuilder;

			var name:String;
			if (props.has(LevelProperties.NAME)) {
				name = props.get(LevelProperties.NAME);
			}
			if (name in unitMap) {
			  unitBuilder = unitMap[name].withName(name);
			} else if ((props.has(LevelProperties.TYPE) && props.get(LevelProperties.TYPE) in unitMap)) {
				if (name == "") {
					name = generateRandomName();
				}
			  unitBuilder = unitMap[props.get(LevelProperties.TYPE)].withName(name);
 			}

			unitBuilder.withX(spawn.x)
					.withY(spawn.y)
					.withFaction(props.get(LevelProperties.FACTION));
			var unit:AiUnitModel = unitBuilder.build(AiUnitModel) as AiUnitModel;

			var groups:Vector.<String> = new Vector.<String>();
			addGroupsFromObject(spawn.properties, groups);
			addGroupsFromMapGroups(unit, groups);


			for each(var group:String in groups) {
				if (!(group in groupMap)) {
					groupMap[group] = new Vector.<UnitModel>();
				}
				var unitList:Vector.<UnitModel> = groupMap[group];
				unitList.push(unit);
			}
			if (props.has(LevelProperties.ACTIVE)) {
				unit.active = (props.get(LevelProperties.ACTIVE) == "true")
			}
			trace("Spawning unit " + unit.name + " with groups " + groups.toString());
			unit.groups = groups;

			return unit;
		}

		protected function registerUnitMap(obj:Object):void {
			this.unitMap = obj;
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
					addGroupsFromObject(trigger.properties, groups);
				}
			}
			for each(var group:String in groups) {
				for each(var aiunit:AiUnitModel in groupMap[group]) {
					trace("Waking up " + aiunit.toString());
					aiunit.activate(true);
				}
			}
		}

		protected function generateRandomName():String {
			return "Pokey";
		}

	}
}