package com.dreamofninjas.battler.levels
{
	import com.dreamofninjas.battler.models.UnitModelBuilder;
	import com.dreamofninjas.core.engine.MapLoader;
	import com.dreamofninjas.core.interfaces.IRectangle;
	import com.dreamofninjas.core.util.BaseLoader;
	
	import flash.utils.Dictionary;
	
	import io.arkeus.tiled.TiledLayer;
	import io.arkeus.tiled.TiledObject;
	import io.arkeus.tiled.TiledObjectLayer;
	import io.arkeus.tiled.TiledProperties;
	
	import starling.events.Event;
	
	public class LevelLoader extends BaseLoader
	{
		private var mapLoader:MapLoader;
		
		public function LevelLoader(fileName:String)
		{
			super();
			mapLoader = new MapLoader("assets/maps/", fileName);
			mapLoader.addEventListener(Event.COMPLETE, mapLoaded);
		}
		
		public override function load(timeout:uint=0):void {
			mapLoader.load(timeout);
		}
		
		protected function mapLoaded(evt:Event):void {
			var typeMap:Dictionary = new Dictionary();
			
			for each (var layer:TiledLayer in evt.data.tiledMap.layers.getAllLayers()) {
				if (layer is TiledObjectLayer) {
					loadObjects(typeMap, layer as TiledObjectLayer);
				}
			}
			
			var spawns:Vector.<UnitSpawnInfo> = new Vector.<UnitSpawnInfo>();
			for each(var spawn:TiledObject in typeMap[LevelObjects.SPAWN]) {
				// Create Spawn Event
				var spawnInfo:UnitSpawnInfo = new UnitSpawnInfo(spawn.x, spawn.y);
				var props:TiledProperties = spawn.properties;			
				var unitBuilder:UnitModelBuilder;
				var name:String;
				spawnInfo.faction = props.get(LevelProperties.FACTION);
				
				if (props.has(LevelProperties.NAME)) {
					spawnInfo.name = props.get(LevelProperties.NAME);
				}
				if (props.has(LevelProperties.TYPE)) {
					spawnInfo.type = props.get(LevelProperties.TYPE);
				}
				if (props.has(LevelProperties.ACTIVE)) {
					spawnInfo.active = (props.get(LevelProperties.ACTIVE) == "true")
				}
				
				var groups:Vector.<String> = new Vector.<String>();
				props.addToVector(LevelProperties.GROUP, groups);
				addGroupsFromMapGroups(typeMap["UnitGroup"], spawn, groups);
				
				spawns.push(spawnInfo);
			}
			loadComplete({atlases: evt.data.atlases, 
				tiledMap:evt.data.tiledMap,
				typeMap:typeMap,
				spawns:spawns
			});
		}
		
		private function loadObjects(typeMap:Dictionary, layer:TiledObjectLayer):void {
			for (var type:String in layer.typeMap) {
				var obj:Vector.<TiledObject> = layer.typeMap[type];
				// Apply layer properties to tile
				obj.forEach(function(item:TiledObject, index:int, vector:Vector.<TiledObject>):void {
					item.properties.extend(layer.properties);
				});
				
				if (typeMap.hasOwnProperty(type)) {
					typeMap[type] = (typeMap[type] as Vector.<TiledObject>).concat(obj);
				} else {
					typeMap[type] = obj;
				}
			}
		}
		
		private function addGroupsFromMapGroups(typeVector:Vector.<TiledObject>, unit:IRectangle, groups:Vector.<String>):int {
			var groupsAdded:int = 0;
			for each(var group:TiledObject in typeVector) {
				if (group.contains(unit)) {
					groupsAdded += group.properties.addToVector(LevelProperties.GROUP, groups);
				}
			}
			return groupsAdded;
		}
	}
}