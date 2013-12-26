package com.dreamofninjas.core.util {
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;


public class AssetLoader extends BaseLoader {


	protected var _swfLoader:Loader;
	protected var _swfLoaderInfo:LoaderInfo;
	protected var _swfLoaderCompleteCallback:Function;
	protected var _swfLoaderProgressCallback:Function;
  protected var _swfPath:String;

  function AssetLoader(swfPath:String, swfLoaderProgressCallback:Function=null) {
    super();
    _swfLoaderProgressCallback = swfLoaderProgressCallback;
    _swfPath = swfPath;
		_swfLoader = new Loader();

  }

  public override function load(timeout:uint=0):void {
    super.load(timeout);

		_swfLoaderInfo = _swfLoader.contentLoaderInfo;

		_swfLoaderInfo.addEventListener(Event.COMPLETE, loadSwfCompleteHandler);
		if (_swfLoaderProgressCallback != null) {
			_swfLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _swfLoaderProgressCallback);
    }
		var request:URLRequest = new URLRequest(_swfPath);
		var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
		loaderContext.checkPolicyFile = true;
		_swfLoader.load(request, loaderContext);
	}
	private function loadSwfCompleteHandler(event:Event):void {
		_swfLoaderInfo.removeEventListener(Event.COMPLETE, loadSwfCompleteHandler);
		if (_swfLoaderProgressCallback != null) {
			_swfLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, _swfLoaderProgressCallback);
		}
    loadComplete(_swfLoader.content);
	}
}
}
