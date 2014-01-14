package com.dreamofninjas.battler
{
	public final class StatType {
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

		public var name:String;
		public function StatType(name:String) {
			this.name = name;
		}
	}
}