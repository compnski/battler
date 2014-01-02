package com.dreamofninjas.core.app
{
	import starling.events.Event;

	public class GameStateController
	{
		private var currentFlow:IFlow = null;
		private var flowStack:Vector.<IFlow> = new Vector.<IFlow>;

		public function GameStateController() {
		}
		
		public function setNextFlow(flow:IFlow):void {
			trace("Starting flow " + flow.name());
			if (currentFlow != null) {
				flowStack.push(currentFlow);
				currentFlow.Suspended();
			}
			currentFlow = flow;
			currentFlow.onComplete(flowComplete);
			currentFlow.Execute();
		}
		
		private function flowComplete(evt:Event):void {
			var flow:IFlow = evt.target as IFlow;
			if (flow.name() != currentFlow.name()) {
				throw new Error("Only currentFlow can complete. flow=" + flow + " currentFlow=" + currentFlow);
			}
			currentFlow = flowStack.pop();
			currentFlow.Restored(evt);
		}
		
	}
}