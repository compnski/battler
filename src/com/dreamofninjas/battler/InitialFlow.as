package com.dreamofninjas.battler
{
	public class InitialFlow extends BaseFlow
	{
		public function InitialFlow(flow:IFlow) {
			setNextFlow(flow);
		}
	}
}