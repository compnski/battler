package com.dreamofninjas.battler.models
{
	
	import flash.utils.Dictionary;
	import flash.utils.describeType;


	public class UnitModelBuilder {
		private var name:String;
		private var faction:String;
		private var job:String;
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
			this.job = type;
			return this;
		}

		public function withJob(job:String):UnitModelBuilder {
			this.job = job;
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
			this.props[BaseUnitModel.STR] = amt;
			return this;
		}

		public function withDex(amt:int):UnitModelBuilder {
			this.props[BaseUnitModel.DEX] = amt;
			return this;
		}

		public function withInt(amt:int):UnitModelBuilder {
			this.props[BaseUnitModel.INT] = amt;
			return this;
		}

		public function withFai(amt:int):UnitModelBuilder {
			this.props[BaseUnitModel.FAI] = amt;
			return this;
		}

		public function withPDef(amt:int):UnitModelBuilder {
			this.props[BaseUnitModel.PDEF] = amt;
			return this;
		}

		public function withMDef(amt:int):UnitModelBuilder {
			this.props[BaseUnitModel.MDEF] = amt;
			return this;
		}

		public function withHp(amt:int):UnitModelBuilder {
			this.props[BaseUnitModel.HP] = amt;
			return this;
		}

		public function withMp(amt:int):UnitModelBuilder {
			this.props[BaseUnitModel.MP] = amt;
			return this;
		}

		public function withMove(amt:int):UnitModelBuilder {
			this.props[BaseUnitModel.MOVE] = amt;
			return this;
		}

		public function build(klass:Class = null):BaseUnitModel {
			if (klass == null) {
				klass = UnitModel;
			}

			var numArgs:int = describeType(klass)..constructor.parameter.length();
			
			var unit:BaseUnitModel;
			if (numArgs == 6 ) {
				unit = new klass(name, faction, job, x, y, this.props);
			} else {
				unit = new klass(name, job, this.props);
			}
			unit.id = this.id; //todo - clean this up
			return unit;
		}
	}
}