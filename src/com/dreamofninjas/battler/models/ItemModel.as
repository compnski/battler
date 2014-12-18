package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.core.app.BaseModel;
	import com.dreamofninjas.core.engine.StatType;
	
	import flash.utils.Dictionary;
	
	public class ItemModel extends BaseModel
	{
		
		// Map of StatType to value
		private var _properties:Dictionary;
		
		public function get name():String { return this._properties['name']; }	
		public function get icon():String { return this._properties['icon']; }	
			
		public function get type():String { return this._properties['type']; }	
		public function get slot():String { return this._properties['slot']; }	

		
		
		public function get equipped():Boolean {
			return "equip" in this._properties && this._properties["equip"];
		}
	
		public function ItemModel(props:Dictionary) {
			super();
			this._properties = props;
		}
		
		// Returns the value of a given StatType on the item. 0 if it doesn't exist. 
		public function getStatValue(type:StatType):int {
			if (type in this._properties) {
				return this._properties[type];
			}
			return 0;
		}
	}
}