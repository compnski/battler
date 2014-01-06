package com.dreamofninjas.battler.views
{
	import com.dreamofninjas.battler.models.AttackModel;
	import com.dreamofninjas.core.app.BaseView;
	import com.dreamofninjas.core.ui.DisplayFactory;
	
	import flash.geom.Rectangle;
	
	import starling.display.Quad;
	import starling.events.Event;
	
	public class AttackView extends BaseView {
		private var attack:AttackModel;
		public function AttackView(attack:AttackModel) {
			super(new Rectangle(0, 0, 320, 40));
			this.attack = attack;

			addEventListener(Event.ADDED_TO_STAGE, addedToStage);			
		}
		
		private function addedToStage(evt:Event):void {
			var q:Quad = new Quad(320, 40, 0x887733); 
			addChild(q);
			q = new Quad(316, 36, 0xaa9944);
			q.x = 2;
			q.y = 2;

			addChild(q);
		}
	}
}