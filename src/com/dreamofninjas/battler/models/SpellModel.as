package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.core.app.BaseModel;
	
	public class SpellModel extends BaseModel
	{
		
		private var _spellType:SpellType;
		private var _range:int;
		private var _targetType:TargetType; //ENUM? friendly/enemy/all
		private var _targetTemplate:TemplateType; //ENUM
		private var _targetSize:int; //maybe
		
		//Aura?
		//Effects?
		//requirements? - weapon type, stats?
		
		
		public function SpellModel()
		{
			super();
		}
	}
}
internal class TemplateType { }
internal class TargetType { }

internal class SpellType {
	public static const ATTACK:String = "attack";
	public static const HEAL:String = "heal";
}