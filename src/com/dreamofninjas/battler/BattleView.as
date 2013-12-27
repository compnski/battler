package com.dreamofninjas.battler
{
	import com.dreamofninjas.core.app.BaseView;
	
	import flash.geom.Rectangle;
	
	public class BattleView extends BaseView
	{
		public function BattleView(battleModel:BattleModel)
		{
			super(new Rectangle(0, 0, 1280, 720));
		}
	}
}