package catfishqa.windows 
{
	import flash.display.NativeWindow; 
	import flash.display.NativeWindowDisplayState;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import fl.controls.Button;
	import fl.controls.Label;
	
	public class MessageBox extends NativeWindowInitOptions 
	{
		private var _newWindow:NativeWindow;
		
		private var _label1:Label = new Label();
		private var _button1:Button = new Button();
		
		public function MessageBox(textMessage:String, title:String) 
		{
			super();
			
			transparent = false; 
			systemChrome = NativeWindowSystemChrome.STANDARD; 
			type = NativeWindowType.UTILITY;
			     
			_newWindow = new NativeWindow(this); 
			_newWindow.title = title; 
			_newWindow.width = 350; 
			_newWindow.height = 150; 
			_newWindow.stage.color = 0xDDDDDD;
			_newWindow.alwaysInFront = true; // всегда поверх других окон
			
			_newWindow.stage.align = StageAlign.TOP_LEFT; 
			_newWindow.stage.scaleMode = StageScaleMode.NO_SCALE; 
			_newWindow.activate();
			
			_label1.text = textMessage;
			_label1.wordWrap = true;
			_label1.x = 10;
			_label1.y = 10;
			_label1.width = 300;
			_label1.height = 100;
			_newWindow.stage.addChild(_label1);
			
			_button1.label = "OK";
			_button1.x = 125; _button1.y = 80;
			_button1.addEventListener(MouseEvent.CLICK, onButton1MouseClick);
			_newWindow.stage.addChild(_button1);
		}
		
		private function onButton1MouseClick(e:MouseEvent):void 
		{
			_newWindow.close();
		}
		
	}

}