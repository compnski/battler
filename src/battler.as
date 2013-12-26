package
{
  import com.dreamofninjas.battler.BattlerStage;
  import com.dreamofninjas.core.util.AssetLoader;
  
  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  
  import starling.core.Starling;

  [SWF(width="1280", height="768", frameRate="60", backgroundColor="#000000")]

  public class battler extends Sprite
  {
    public function battler()
    {
      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    protected var _assetLoader:AssetLoader;
    protected var _starling:Starling;

    private function onAddedToStage(event:Event):void
    {
      removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	  var swfPath:String = "../assets/assets.swf";
	  _assetLoader = new AssetLoader(swfPath);
	  _assetLoader.addEventListener(Event.COMPLETE, initApp);
	  _assetLoader.load();
   }

    private function initApp():void {
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;

        _starling = new Starling(BattlerStage, stage)
				_starling.showStats = true;
				_starling.antiAliasing = 1;
				_starling.start();
    }
  }
}
