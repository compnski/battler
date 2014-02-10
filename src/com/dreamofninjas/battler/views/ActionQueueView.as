package com.dreamofninjas.battler.views
{
	import com.dreamofninjas.battler.models.Action;
	import com.dreamofninjas.battler.models.ActionQueue;
	import com.dreamofninjas.battler.models.TurnAction;
	import com.dreamofninjas.core.app.BaseView;
	
	import flash.geom.Rectangle;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class ActionQueueView extends BaseView
	{
		private var textField:TextField = new TextField(200, 800, "");
		private var actionQueue:ActionQueue;
		
		public function ActionQueueView(actionQueue:ActionQueue)
		{
			super(new Rectangle(0,0,200,800));
			this.actionQueue = actionQueue;
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			actionQueue.addEventListener(Event.CHANGE, modelUpdated);
		}
		
		private function addedToStage(evt:Event):void {
			modelUpdated(null);
			var q:Quad = new Quad(200, 800, 0xFFFFFF);
			q.alpha = 0.3;
			addChild(q);
			addChild(textField);
		}
		
		private function modelUpdated(evt:Event):void {
			this.textField.text = this.actionQueue.queue.filter(function(item:Action, _, _):Boolean { return !(item is TurnAction) || (item as TurnAction).unit.active; }).join("\n")
		}		
	}
}