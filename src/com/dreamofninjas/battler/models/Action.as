package com.dreamofninjas.battler.models
{
	public class Action
	{		
		public var at:int;
		public var name:String;
		//TODO: Find an interface for creator
		public function Action(name:String, at:int, faction:String, creator:Object)
		{
			this.name = name;
			this.at = at;
		}
		
		public function toString():String {
			return "@" + this.at + "+, " + this.name
		}
	}
}