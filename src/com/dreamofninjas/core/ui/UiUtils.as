package com.dreamofninjas.core.ui
{
	
	import starling.display.Sprite;
	import starling.events.Event;

	public final class UiUtils
	{
		public function UiUtils()
		{
		}
		
		// To be used as an event listener when you want the event to cause the sprites to be removed from the dispaly list
		public static function DisposeSprite(evt:Event):void {
			(evt.data as Sprite).removeFromParent(true);
		}
	}
}