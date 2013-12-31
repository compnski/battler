package com.dreamofninjas.battler.flows
{

	public class InitialFlow extends BaseFlow
	{
		public function InitialFlow(flow:IFlow) {
			super();
			setNextFlow(flow);
		}
	}
}