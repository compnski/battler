package com.dreamofninjas.battler.models {
 public final class DamageType {
	public static const PHYSICAL:DamageType = new DamageType(0);
	public static const MAGIC:DamageType = new DamageType(1);
	
	private var id:int;
	
	function DamageType(id:int) {
		this.id = id;
	}
	
	public function toString():String {
		return this.id.toString();
	}
}}