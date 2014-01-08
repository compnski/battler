package com.dreamofninjas.battler.views
{
	import com.dreamofninjas.battler.DamageType;
	import com.dreamofninjas.battler.models.AttackModel;
	import com.dreamofninjas.battler.models.UnitModel;
	import com.dreamofninjas.core.app.BaseView;
	
	import flash.geom.Rectangle;
	
	import starling.display.Button;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	public class AttackView extends BaseView {
		private var attack:AttackModel;
		private var target:UnitModel;
		private var button:Button;
		
		public function AttackView(attack:AttackModel) {
			super(new Rectangle(0, 0, 320, 40));
			this.attack = attack;
			this.touchable = true;

			addEventListener(Event.CHANGE, modelUpdated);
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function set enabled(s:Boolean):void {
			this.button.enabled = s;
		}
		
		private function onTouch(evt:Event):void {
			evt.stopPropagation();
		}
		
		private function buttonClicked(evt:Event):void {
			trace("Clicked");
			evt.stopImmediatePropagation();
			dispatchEvent(new Event(Event.TRIGGERED, true, attack));
		}
		
		private function initUi():void {
			width = 320;
			height = 40;

			var upTexture:Texture = generateTexture(320, 40);
			button = new Button(upTexture);
			button.addEventListener(Event.TRIGGERED, buttonClicked);

			addChild(button);			
		}
		
		
		private function generateTexture(w:int, h:int):Texture {
			var texture:RenderTexture = new RenderTexture(w, h, true);			
			texture.drawBundled(function():void {
				
				
				var t:TextField = new TextField(30, h, attack.iconText, "Verdana", 24);
				t.x = 20;
				t.y = -3;
				var t2:TextField = new TextField(100, h, attack.getAttackRating().toString());
				t2.x = 10;
				
				var q:Quad = new Quad(w, h, 0xCEC1E1);
				texture.draw(q);
				texture.draw(t);
				texture.draw(t2);				
			});
			return texture;
		}
		
		private function modelUpdated(evt:Event):void {
			
		}
		
		private function addedToStage(evt:Event):void {
			initUi();
		}
	}
}