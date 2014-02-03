package com.dreamofninjas.core.app
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.events.Event;

	public class GameStateController
	{
		private var currentFlow:IFlow = null;
		private var flowStack:Vector.<IFlow> = new Vector.<IFlow>;

		public function GameStateController() {
		}
		public function get juggler():Juggler {
			return Starling.juggler
		}
		
		public function setNextFlow(flow:IFlow):void {
			trace("Starting flow " + flow.name());
			if (currentFlow != null) {
				flowStack.push(currentFlow);
				trace("Suspensing " + currentFlow);
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
			trace("Restoring " + currentFlow);
			var t:Timer = new Timer(0,1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, function(tevt:TimerEvent):void {
				currentFlow.Restored(evt);
				t.removeEventListener(TimerEvent.TIMER_COMPLETE, arguments.callee);
			});
			t.start();
		}
		
	}
}