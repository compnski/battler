package com.dreamofninjas.core.util 
{
	
  import starling.events.Event;

  import io.arkeus.tiled.TiledMap;

	public class TmxMapLoader extends BaseLoader {

    protected var _path:String;
    protected var _xmlLoader:XmlLoader;
    protected var _tmxMap:TiledMap;
    protected var _assetPath:String;

    /* Loads a TMX map and all of it's assets.
    */
    function TmxMapLoader(assetPath:String, mapPath:String){
      _assetPath = assetPath;
      _xmlLoader = new XmlLoader(assetPath + mapPath);
    }

    public override function load(timeout:uint=0):void {
      super.load(timeout);
			_xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
      _xmlLoader.load();
    }

    private function xmlLoaded(evt:Event):void {
			var xml:XML = evt.data as XML;
      _tmxMap = new TiledMap(_assetPath, xml);
      _tmxMap.addEventListener(Event.COMPLETE, tmxLoaded);
      _tmxMap.load();
    }

		private function tmxLoaded(evt:Event):void {
			loadComplete(evt.data as TiledMap);
		}
	}
}