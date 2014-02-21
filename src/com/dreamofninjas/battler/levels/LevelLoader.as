package com.dreamofninjas.battler.levels
{
	import com.dreamofninjas.battler.models.LevelModel;
	import com.dreamofninjas.battler.models.MapModel;
	import com.dreamofninjas.battler.models.PlayerModel;
	import com.dreamofninjas.battler.models.UnitModelBuilder;
	import com.dreamofninjas.core.engine.MapLoader;
	import com.dreamofninjas.core.engine.SpriteManager;
	import com.dreamofninjas.core.interfaces.IRectangle;
	import com.dreamofninjas.core.util.BaseLoader;
	
	import flash.utils.Dictionary;
	
	import io.arkeus.tiled.TiledLayer;
	import io.arkeus.tiled.TiledObject;
	import io.arkeus.tiled.TiledObjectLayer;
	import io.arkeus.tiled.TiledProperties;
	
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.utils.AssetManager;
	
	public class LevelLoader extends BaseLoader
	{
		private var mapLoader:MapLoader;
		
		private var _playerModel:PlayerModel;
		private var _levelClass:Class;
		
		public function LevelLoader(fileName:String, levelClass:Class, playerModel:PlayerModel)
		{
			super();
			this._levelClass = levelClass;
			this._playerModel = playerModel;
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
			
			var spawns:Vector.<UnitSpawnInfo> = createSpawns(typeMap);
			var doodads:Vector.<MovieClip> = createDoodads(typeMap);
			
			var mapModel:MapModel = new MapModel(evt.data.tiledMap);
			var levelModel:LevelModel = new this._levelClass(this._playerModel, mapModel, typeMap, spawns); 
			
			var assetManager:AssetManager = new AssetManager();
			for each (var atlas:Object in evt.data.atlases) {
				assetManager.addTextureAtlas(atlas.name, atlas.textures);
			}
			
			loadComplete({assetManager: assetManager,
										mapModel: mapModel,
										levelModel: levelModel,
										doodads:doodads});			
		}
	
		private function createDoodads(typeMap:Object):Vector.<MovieClip> {
			var doodads:Vector.<MovieClip> = new Vector.<MovieClip>();
			var s:SpriteManager = SpriteManager.get();
			for each(var spawn:TiledObject in typeMap[LevelObjects.DOODAD]) {
				doodads.push(s.getDoodad(spawn.properties.get(LevelProperties.CLIP), spawn.x, spawn.y));
			}
			return doodads;
		}
		
		private function createSpawns(typeMap:Object):Vector.<UnitSpawnInfo> {
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
			return spawns;
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