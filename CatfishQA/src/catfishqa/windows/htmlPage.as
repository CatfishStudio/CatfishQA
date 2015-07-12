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
	import fl.controls.ScrollBar;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	public class htmlPage extends NativeWindowInitOptions 
	{
		private var _newWindow:NativeWindow;
		private var _movieClip:MovieClip;
		private var _link:String;
		private var _htmlLoader:HTMLLoader;
		private var _scrollBarH:ScrollBar;
		private var _scrollBarV:ScrollBar;
		private var _comboBox:ComboBox = new ComboBox();
		
		private var _box:Array = [];
		
		public function htmlPage(link:String) 
		{
			super();
			_link = link;
			_box.push( { label:_link, data:_link } );
			_box.push( { label:"https://www.google.com.ua/", data:"https://www.google.com.ua/" } );
			
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
			_htmlLoader.width = _newWindow.stage.stageWidth - 16;
			_htmlLoader.height = _newWindow.stage.stageHeight - (16 + 25);
			_scrollBarV.height = _newWindow.stage.stageHeight - 16;
			_scrollBarV.x = _newWindow.stage.stageWidth - 16;
			_scrollBarH.width = _newWindow.stage.stageWidth - 16;
			_scrollBarH.x = 0;
			_scrollBarH.y = _newWindow.stage.stageHeight - 16;
			_comboBox.dropdownWidth = _newWindow.stage.stageWidth - 16; 
			_comboBox.width = _newWindow.stage.stageWidth - 16;  
			
		}
		
		private function pageShow():void
		{ 	
			_comboBox.x = 0; 
			_comboBox.y = 0;
			_comboBox.text = _link;
			_comboBox.name = "comboBox";
			_comboBox.dropdownWidth = _newWindow.stage.stageWidth - 16; 
			_comboBox.width = _newWindow.stage.stageWidth - 16;  
			_comboBox.selectedIndex = 0;
			_comboBox.dataProvider = new DataProvider(_box);
			_comboBox.addEventListener(Event.CHANGE, onChangeComboBox); 
			_newWindow.stage.addChild(_comboBox);
			
			_scrollBarV = new ScrollBar();
			_scrollBarV.height = _newWindow.stage.stageHeight - 16;
			_scrollBarV.x = _newWindow.stage.stageWidth - 16;
			_scrollBarV.addEventListener(Event.SCROLL, scrollVerticalHandler);
			_newWindow.stage.addChild(_scrollBarV);
			
			_scrollBarH = new ScrollBar();
			_scrollBarH.direction = "horizontal";
			_scrollBarH.width = _newWindow.stage.stageWidth - 16;
			_scrollBarH.x = 0;
			_scrollBarH.y = _newWindow.stage.stageHeight - 16;
			_scrollBarH.addEventListener(Event.SCROLL, scrollHorizontalHandler);
			_newWindow.stage.addChild(_scrollBarH);
			
			
			_movieClip = new MovieClip();
			_htmlLoader = new HTMLLoader();
			_htmlLoader.y = 25;
			_htmlLoader.width = _newWindow.stage.stageWidth - 16;
			_htmlLoader.height = _newWindow.stage.stageHeight - (16 + 25);
			_htmlLoader.load(new URLRequest(_link));
			_htmlLoader.addEventListener(Event.COMPLETE, completeHandler);
			_htmlLoader.addEventListener(Event.SCROLL, scrollHandler);
			_movieClip.addChild(_htmlLoader);
			_newWindow.stage.addChild(_movieClip);
		}
		
		private function onChangeComboBox(e:Event):void 
		{
			_link = ComboBox(e.target).selectedItem.data;
			_htmlLoader.load(new URLRequest(_link));
		}
		
		private function completeHandler(e:Event):void 
		{
			_htmlLoader.scrollH = 0;
			_htmlLoader.scrollV = 0;
			_scrollBarV.setScrollProperties(_htmlLoader.height, 0, _htmlLoader.contentHeight - _htmlLoader.height);
			_scrollBarH.setScrollProperties(_htmlLoader.width, 0, _htmlLoader.contentWidth - _htmlLoader.width);
		}
		
		private function scrollHandler(e:Event):void 
		{
			_scrollBarV.scrollPosition =  _htmlLoader.scrollV;
		}
		
		private function scrollHorizontalHandler(e:Event):void 
		{
			_htmlLoader.scrollH = _scrollBarH.scrollPosition;
		}
		
		private function scrollVerticalHandler(e:Event):void 
		{
			_htmlLoader.scrollV = _scrollBarV.scrollPosition;
		}
	}

}