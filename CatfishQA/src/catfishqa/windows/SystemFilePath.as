package catfishqa.windows 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	
	import fl.controls.Button;
	import fl.controls.TextInput;
	import fl.controls.ComboBox;
	import fl.controls.Label;
	import fl.data.DataProvider; 
	import fl.events.ComponentEvent;
	
	import catfishqa.resource.Resource;
	import catfishqa.server.Server;
	
	public class SystemFilePath extends Sprite
	{
		private var _label1:Label = new Label();
		private var _label2:Label = new Label();
		private var _textBox1:TextInput = new TextInput();
		private var _label3:Label = new Label();
		private var _comboBox1:ComboBox = new ComboBox();
		private var _button1:Button = new Button();
		private var _button2:Button = new Button();
		
		public function SystemFilePath() 
		{
			super();
			name = Resource.PATH;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_label1.text = "Инициализация сервера:"; 
			_label1.x = 10;
			_label1.y = 110;
			_label1.width = 250;
			addChild(_label1);
			
			_label2.text = "Адрес:"; 
			_label2.x = 10;
			_label2.y = 140;
			addChild(_label2);
			
			_textBox1.text = "http://localhost/qa/";
			_textBox1.x = 60; _textBox1.y = 140;
			_textBox1.width = 200;
			addChild(_textBox1);
			
			_button1.label = "ОК";
			_button1.x = 10; _button1.y = 220;
			_button1.addEventListener(MouseEvent.CLICK, onButton1MouseClick);
			this.addChild(_button1);
			
			_button2.label = "Отмена";
			_button2.x = 160; _button2.y = 220;
			_button2.addEventListener(MouseEvent.CLICK, onButton2MouseClick);
			this.addChild(_button2);
		}
		
		private function onButton1MouseClick(e:MouseEvent):void 
		{
			var file:File = File.desktopDirectory.resolvePath("path_qa.txt");
			if (file.exists == true)
			{
				var streamW:FileStream = new FileStream();
				streamW.open(file, FileMode.WRITE);
				streamW.writeUTFBytes(_textBox1.text);
				streamW.close();
				dispatchEvent(new Event(Event.CLOSE));
			}
		}
		
		private function onButton2MouseClick(e:MouseEvent):void 
		{
			_textBox1.text = "http://";
		}
		
	}

}