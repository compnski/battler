package com.dreamofninjas.battler.models
{
	import io.arkeus.tiled.TiledProperties;

	public class Terrain {
		public var name:String;
		public var properties:TiledProperties;
		
		public function Terrain(name:String, properties:TiledProperties) {
			this.name = name;
			this.properties = properties;
		}
	}
}