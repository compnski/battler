package com.dreamofninjas.battler.models
{
	public class TurnAction extends Action
	{
		public var unit:UnitModel;
		
		public function TurnAction(unit:UnitModel, at:int)
		{
			super("Turn for " + unit.id + " on " + unit.faction, at, unit.faction, unit);
			this.unit = unit;
		}
	}
}