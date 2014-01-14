package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.battler.StatType;
	
	import flash.utils.Dictionary;


	public class UnitModelBuilder {
		private var name:String;
		private var faction:String;
		private var type:String;
		private var x:int;
		private var y:int;
		private var id:int;
		private var props:Dictionary = new Dictionary();

		public function UnitModelBuilder(name:String, faction:String, type:String, x:int, y:int) {
			this.name = name;
			this.type = type;
			this.faction = faction;
			this.x = x;
			this.y = y;
		}

		public function withStr(amt:int):UnitModelBuilder {
			this.props[StatType.STR] = amt;
			return this;
		}

		public function withDex(amt:int):UnitModelBuilder {
			this.props[StatType.DEX] = amt;
			return this;
		}

		public function withInt(amt:int):UnitModelBuilder {
			this.props[StatType.INT] = amt;
			return this;
		}

		public function withFai(amt:int):UnitModelBuilder {
			this.props[StatType.FAI] = amt;
			return this;
		}

		public function withPDef(amt:int):UnitModelBuilder {
			this.props[StatType.PDEF] = amt;
			return this;
		}

		public function withMDef(amt:int):UnitModelBuilder {
			this.props[StatType.MDEF] = amt;
			return this;
		}

		public function withHp(amt:int):UnitModelBuilder {
			this.props[StatType.HP] = amt;
			return this;
		}

		public function withMp(amt:int):UnitModelBuilder {
			this.props[StatType.MP] = amt;
			return this;
		}

		public function withCharId(id:int):UnitModelBuilder {
			this.id = id;
			return this;
		}
		
		public function build():UnitModel {
			var unit:UnitModel = new UnitModel(name, faction, type, x, y, this.props);
			unit.id = this.id; //todo - clean this up
			return unit;
		}
	}
}