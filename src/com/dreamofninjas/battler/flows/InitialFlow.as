package com.dreamofninjas.battler.flows
{
	import com.dreamofninjas.core.interfaces.IFlow;
	import com.dreamofninjas.core.app.BaseFlow;

	public class InitialFlow extends BaseFlow
	{
		public function InitialFlow(flow:IFlow) {
			super();
			setNextFlow(flow);
		}
	}
}