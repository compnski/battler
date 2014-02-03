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

		public function UnitModelBuilder() { }

		public function withName(name:String):UnitModelBuilder {
			this.name = name;
			return this;
		}

		public function withType(type:String):UnitModelBuilder {
			this.type = type;
			return this;
		}

		public function withFaction(faction:String):UnitModelBuilder {
			this.faction = faction;
			return this;
		}

		public function withX(x:int):UnitModelBuilder {
			this.x = x;
			return this;
		}

		public function withY(y:int):UnitModelBuilder {
			this.y = y;
			return this;
		}

		public function withCharId(id:int):UnitModelBuilder {
			this.id = id;
			return this;
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

		public function withMove(amt:int):UnitModelBuilder {
			this.props[StatType.MOVE] = amt;
			return this;
		}

		public function build(klass:Class = null):UnitModel {
			if (klass == null) {
				klass = UnitModel;
			}
			var unit:UnitModel = new klass(name, faction, type, x, y, this.props);
			unit.id = this.id; //todo - clean this up
			return unit;
		}
	}
}