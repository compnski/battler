package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.core.app.BaseModel;
	import com.dreamofninjas.core.engine.StatType;
	
	import flash.utils.Dictionary;

	public class CharacterModel extends BaseModel
	{

		public var name:String;
		public var job:String;
		public var xp:int;

		private var str:int;
		private var dex:int;
		private var intl:int;
		private var fai:int;
		private var att:int;
		private var move:int;
		private var equip:Vector.<ItemModel> = new Vector.<ItemModel>();
		private var faction:String = "Player";

		public function CharacterModel(name:String, job:String, xp:int) {
			this.name = name;
			this.job = job;
			this.xp = xp;
		}

		public static function LoadFromJsonObj(obj:Object):CharacterModel {
			var c:CharacterModel = new CharacterModel(obj["name"], obj["job"], obj["xp"]);
			c.str = obj["str"];
			c.dex = obj["dex"];
			c.intl = obj["intl"];
			c.fai = obj["fai"];
			c.att = obj["att"];
			c.move = obj["move"];

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
			return getStatFromGear(UnitModel.PDEF);
		}
		private function get mdef():int {
			return getStatFromGear(UnitModel.MDEF);
		}
		private function get hp():int {
			return (this.level * 2) + getStatFromGear(UnitModel.HP);

		}
		private function get mp():int {
			return getStatFromGear(UnitModel.MP);
		}

		private function getStatFromGear(stat:StatType):int {
			var statVal:int = 0;
			for each(var item:ItemModel in this.equip) {
				statVal += item.getStatValue(stat);
			}
			return statVal;
		}

		public function getUnitBuilder():UnitModelBuilder
		{
			return (new UnitModelBuilder()
				.withName(this.name)
				.withFaction(this.faction)
				.withJob(this.job)
				.withStr(this.str)
				.withDex(this.dex)
				.withInt(this.intl)
				.withFai(this.fai)
				.withMove(this.move)
				.withPDef(this.pdef)
				.withMDef(this.mdef)
				.withHp(this.hp)
				.withMp(this.mp));
		}
	}
}