package com.dreamofninjas.battler.models
{
	

	public class UnitModelBuilder {
		private var unit:UnitModel;
		
		public function UnitModelBuilder(faction:String, type:String, x:int, y:int) {
			unit = new UnitModel(faction, type, x, y);
		}

		public function withStr(amt:int):UnitModelBuilder {
			unit.Str = amt;
			return this;
		}

		public function withDex(amt:int):UnitModelBuilder {
			unit.Dex = amt;
			return this;
		}

		public function withInt(amt:int):UnitModelBuilder {
			unit.Int = amt;
			return this;
		}

		public function withFai(amt:int):UnitModelBuilder {
			unit.Fai = amt;
			return this;
		}
		
		public function withPDef(amt:int):UnitModelBuilder {
			unit.PDef = amt;
			return this;
		}

		public function withMDef(amt:int):UnitModelBuilder {
			unit.MDef = amt;
			return this;
		}

		public function withHp(amt:int):UnitModelBuilder {
			unit.HP = amt;
			return this;
		}

		public function withMp(amt:int):UnitModelBuilder {
			unit.MP = amt;
			return this;
		}

		public function withSpd(amt:int):UnitModelBuilder {
			unit.Spd = amt;
			return this;
		}

		public function withName(name:String):UnitModelBuilder {
			unit.name = name;
			return this;
		}
		public function withCharId(id:int):UnitModelBuilder {
			unit.id = id;
			return this;
		}
		public function build():UnitModel {
			return unit;
		}
	}
}