package com.dreamofninjas.battler.models
{
	import com.dreamofninjas.core.app.BaseModel;
	import com.dreamofninjas.core.engine.StatProperty;
	import com.dreamofninjas.core.engine.StatType;
	import com.dreamofninjas.core.interfaces.IHasEffects;
	import com.dreamofninjas.core.interfaces.IStatusEffect;
	
	import flash.utils.Dictionary;

	//TODO: Merge this and the builder, remove most of the setters for stats

	public class BaseUnitModel extends BaseModel implements IHasEffects {
		public static const Builder:Class = UnitModelBuilder;

		public static const STR:StatType = new StatType("str");
		public static const INT:StatType = new StatType("dex");
		public static const DEX:StatType = new StatType("int");
		public static const FAI:StatType = new StatType("fai");

		public static const PDEF:StatType = new StatType("pdef");
		public static const MDEF:StatType = new StatType("mdef");

		public static const HP:StatType = new StatType("hp");
		public static const MP:StatType = new StatType("mp");
		public static const ATT:StatType = new StatType("att");

		public static const MOVE:StatType = new StatType("move");

		private var _move:StatProperty;
		public function get Move():int {  return this._move.currentValue() }

		private var _str:StatProperty;
		public function get Str():int {  return this._str.currentValue() }

		private var _dex:StatProperty;
		public function get Dex():int {  return this._dex.currentValue() }

		private var _int:StatProperty;
		public function get Int():int {  return this._int.currentValue() }

		private var _fai:StatProperty;
		public function get Fai():int {  return this._fai.currentValue() }

		private var _att:StatProperty;
		public function get Att():int {  return this._att.currentValue() }

		private var _hp:StatProperty;
		public function get MaxHP():int {  return this._hp.currentValue() }

		private var _mp:StatProperty;
		public function get MaxMP():int {  return this._mp.currentValue() }

		private var _mdef:StatProperty;
		public function get MDef():int {  return this._mdef.currentValue() }

		private var _pdef:StatProperty;
		public function get PDef():int {  return this._pdef.currentValue() }

		public function get Job():String { return this._job }
		
		protected var _job:String; //class?

		public var name:String;
		public var id:int;
		private static var __id:int = 0;

		public var recoveryTime:int = 50;

		private var _properties:Dictionary;
		public function BaseUnitModel(name:String, job:String, properties:Dictionary) {
			this.id = BaseUnitModel.__id++;
			this._str = new StatProperty(this, STR, properties[STR]);
			this._int = new StatProperty(this, INT, properties[INT]);
			this._dex = new StatProperty(this, DEX, properties[DEX]);
			this._fai = new StatProperty(this, FAI, properties[FAI]);
			this._att = new StatProperty(this, ATT, properties[ATT]);
			this._hp =  new StatProperty(this, HP , properties[HP]);
			this._mp =  new StatProperty(this, MP , properties[MP]);
			this._pdef = new StatProperty(this, PDEF, properties[PDEF]);
			this._mdef = new StatProperty(this, MDEF, properties[MDEF]);
			this._move = new StatProperty(this, MOVE, properties[MOVE]);
			
			this._job = job;
			this.name = name;
		}

		private var effects:Vector.<IStatusEffect> = new Vector.<IStatusEffect>();
		public function getEffects():Vector.<IStatusEffect> {
			return effects; //clone?
		}
		////static

		public static function Filter(filter:Function):Function {
			return function(u:BaseUnitModel, idx:int, v:Vector.<BaseUnitModel>):Boolean {
				return filter(u);
			}
		}
		
		public function getUnitBuilder():UnitModelBuilder
		{
			return (new UnitModelBuilder()
				.withName(this.name)
				.withJob(this._job)
				.withStr(this.Str)
				.withDex(this.Dex)
				.withInt(this.Int)
				.withFai(this.Fai)
				.withMove(this.Move)
				.withPDef(this.PDef)
				.withMDef(this.MDef)
				.withHp(this.MaxHP)
				.withMp(this.MaxMP));
		}

	}
}
