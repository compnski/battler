package io.arkeus.tiled {
	/**
	 * A container containing all properties of some part of the map. Many parts of the map, such
	 * as tiles, objects, layers, etc, can contain a set of properties. Each will have a properties
	 * value pointed to a TiledProperties object containing all properties.
	 */
	public class TiledProperties {
		/** The map containing the properties, keyed by name. */
		public var properties:Object = {};
		
		public function TiledProperties(properties:XMLList) {
			for (var i:uint = 0; i < properties.property.length(); i++) {
				set(properties.property[i].@name, properties.property[i].@value);
			}
		}
		
		/**
		 * Returns the property for the given key.
		 * 
		 * @param key The name of the property.
		 * @return The property value.
		 */
		public function get(key:String):String {
			return properties[key];
		}
		
		public function getBool(key:String):Boolean {
			if(!has(key)) {
				return false;
			}
			switch(properties[key].toLowerCase()) {
				case "yes":
				case "true":
					return true;
				default:
					return false;
			}
		}
		
		/**
		 * Sets the property for the given key to the given value.
		 * 
		 * @param key The name of the property.
		 * @param value The property value.
		 */
		public function set(key:String, value:String):void {
			properties[key] = value;
		}
		
		public function has(key:String):Boolean {
			return properties.hasOwnProperty(key);
		}
		
		public function extend(props:TiledProperties):void {
			for (var key:String in props.properties) {
				if(!has(key)) {
					set(key, props.get(key));
				}
			}
		}
		
		public function addToVector(propName:String, groups:Vector.<String>):int {
			var initialLen:int = groups.length;
			if (this.has(propName)) {
				groups.push(this.get(propName));
			}
			return groups.length - initialLen;
		}
		
		/**
		 * Creates a list of all properties.
		 */
		public function toString():String {
			var props:Vector.<String> = new <String>[];
			for (var key:String in properties) {
				props.push(key + "=" + properties[key]);
			}
			return "(" + props.join(", ") + ")";
		}
	}
}
