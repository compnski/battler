package com.dreamofninjas.core.engine
{
	public final class StatType {
		public var name:String;
		private static var _registry:Object = new Object();

		public static function ValueOf(name:String):StatType {
			return _registry[name];
		}

		public function StatType(name:String) {
			this.name = name;
			StatType._registry[name] = this;
		}
	}
}