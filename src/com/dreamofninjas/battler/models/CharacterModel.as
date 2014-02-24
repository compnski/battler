package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.core.engine.StatType;
	
	import flash.utils.Dictionary;

	public class CharacterModel extends BaseUnitModel
	{
		public var job:String;
		public var xp:int;

		private var equip:Vector.<ItemModel> = new Vector.<ItemModel>();
		private var faction:String = "Player";

		public function CharacterModel(name:String, job:String, properties:Dictionary) {
			super(name, job, properties);
		}
		
		public static function LoadFromJsonObj(obj:Object):CharacterModel {
			var ub:UnitModelBuilder = new UnitModelBuilder()
				.withName(obj["name"])
				.withJob(obj["job"])
				.withStr(obj["str"])
				.withDex(obj["dex"])
				.withInt(obj["int"])
				.withFai(obj["fai"])
				.withMove(obj["move"])
				var c:CharacterModel = ub.build(CharacterModel) as CharacterModel;

				for each(var item:Object in obj["items"]) {
					var props:Dictionary = new Dictionary();
					for (var statName:String in item["properties"]) {
						props[StatType.ValueOf(statName)] = item["properties"][statName];
					}
					c.equip.push(new ItemModel(props));
				}
				return c;
			}

		public function serializeToJson():String {
			return "";
		}

		public function get level():int {
			return Math.floor(xp / 100); //TBD
		}

		private function get pdef():int {
			return getStatFromGear(BaseUnitModel.PDEF);
		}
		private function get mdef():int {
			return getStatFromGear(BaseUnitModel.MDEF);
		}
		private function get hp():int {
			return (this.level * 2) + getStatFromGear(BaseUnitModel.HP);

		}
		private function get mp():int {
			return getStatFromGear(BaseUnitModel.MP);
		}

		private function getStatFromGear(stat:StatType):int {
			var statVal:int = 0;
			for each(var item:ItemModel in this.equip) {
				statVal += item.getStatValue(stat);
			}
			return statVal;
		}
		
		public override function getUnitBuilder():UnitModelBuilder
		{
			return (super.getUnitBuilder()
				.withFaction(this.faction));
		}
	}
}