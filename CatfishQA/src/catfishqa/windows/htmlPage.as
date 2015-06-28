package catfishqa.windows 
{
	import flash.display.NativeWindow; 
	import flash.display.NativeWindowDisplayState;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Sprite;
	import flash.events.NativeWindowBoundsEvent;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.html.HTMLLoader;
	import flash.net.URLRequest;
	
	public class htmlPage extends NativeWindowInitOptions 
	{
		private var _newWindow:NativeWindow;
		private var _movieClip:Sprite;
		private var _link:String;
		private var _htmlLoader:HTMLLoader;
		
		public function htmlPage(link:String) 
		{
			super();
			_link = link;
			
			transparent = false; 
			systemChrome = NativeWindowSystemChrome.STANDARD; 
			type = NativeWindowType.NORMAL; 
     
			_newWindow = new NativeWindow(this); 
			_newWindow.title = "Страница"; 
			_newWindow.width = 800; 
			_newWindow.height = 600; 
			_newWindow.stage.color = 0xDDDDDD;
			_newWindow.alwaysInFront = true; // всегда поверх других окон
			
			_newWindow.stage.align = StageAlign.TOP_LEFT; 
			_newWindow.stage.scaleMode = StageScaleMode.NO_SCALE; 
			_newWindow.activate();
			
			_newWindow.addEventListener(Event.CLOSE, onClose);
			_newWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, onResize);
			
			pageShow();
		}
		
		private function onClose(e:Event):void 
		{
			_movieClip = null;
		}
		
		private function onResize(e:Event):void 
		{
			_htmlLoader.width = _newWindow.stage.stageWidth;
			_htmlLoader.height = _newWindow.stage.stageHeight;
		}
		
		private function pageShow():void
		{ 	
			_movieClip = new Sprite();
			_htmlLoader = new HTMLLoader();
			_htmlLoader.width = _newWindow.stage.stageWidth;
			_htmlLoader.height = _newWindow.stage.stageHeight;
			_movieClip.addChild(_htmlLoader);
			_htmlLoader.load(new URLRequest(_link));
			
			_newWindow.stage.addChild(_movieClip);
		}
	}

}