package catfishqa.admin.systemUsers.systemUserNew 
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
	
	import fl.data.DataProvider;
	
	import fl.controls.Button;
	import fl.controls.TextInput;
	import fl.controls.ComboBox;
	import fl.controls.Label;
	
	import catfishqa.mysql.Query;
	import catfishqa.server.Server;
	import catfishqa.windows.MessageBox;
	
	public class SystemUserNew extends NativeWindowInitOptions 
	{
		private var _newWindow:NativeWindow;
		private var _label1:Label = new Label();
		private var _textBox1:TextInput = new TextInput();
		private var _label2:Label = new Label();
		private var _textBox2:TextInput = new TextInput();
		private var _label3:Label = new Label();
		private var _textBox3:TextInput = new TextInput();
		
		private var _label4:Label = new Label();
		private var _comboBox1:ComboBox = new ComboBox();
		
		private var _button1:Button = new Button();
		private var _button2:Button = new Button();
		
		private var userType:Array = new Array( 
			{label:"Администратор", data:"1"},
			{label:"Пользователь", data:"0"} 
		);
		
		private var _query:Query;
		
		public function SystemUserNew() 
		{
			super();
			
			transparent = false; 
			systemChrome = NativeWindowSystemChrome.STANDARD; 
			type = NativeWindowType.NORMAL; 
     
			_newWindow = new NativeWindow(this); 
			_newWindow.title = "Новый пользователь"; 
			_newWindow.width = 350; 
			_newWindow.height = 250; 
			_newWindow.stage.color = 0xDDDDDD;
			_newWindow.alwaysInFront = true; // всегда поверх других окон
			
			_newWindow.stage.align = StageAlign.TOP_LEFT; 
			_newWindow.stage.scaleMode = StageScaleMode.NO_SCALE; 
			_newWindow.activate();
			
			Show();
		}
		
		private function Show():void
		{
			_label1.text = "Имя пользователя:"; 
			_label1.x = 10;
			_label1.y = 10;
			_label1.width = 125;
			_newWindow.stage.addChild(_label1);
			
			_textBox1.text = "";
			_textBox1.x = 125; 
			_textBox1.y = 10;
			_textBox1.width = 200;
			_newWindow.stage.addChild(_textBox1);
			
			
			_label2.text = "Логин пользователя:"; 
			_label2.x = 10;
			_label2.y = 50;
			_label2.width = 125;
			_newWindow.stage.addChild(_label2);
			
			_textBox2.text = "";
			_textBox2.x = 125; 
			_textBox2.y = 50;
			_textBox2.width = 200;
			_newWindow.stage.addChild(_textBox2);
			
			_label3.text = "Пароль:"; 
			_label3.x = 10;
			_label3.y = 90;
			_label3.width = 125;
			_newWindow.stage.addChild(_label3);
			
			_textBox3.text = "";
			_textBox3.x = 125; 
			_textBox3.y = 90;
			_textBox3.width = 200;
			_textBox3.displayAsPassword = true;
			_newWindow.stage.addChild(_textBox3);
			
			_label4.text = "Тип пользователя:"; 
			_label4.x = 10;
			_label4.y = 130;
			_label4.width = 125;
			_newWindow.stage.addChild(_label4);
			
			_comboBox1.x = 125; 
			_comboBox1.y = 130;
			_comboBox1.dropdownWidth = 200; 
			_comboBox1.width = 200;  
			_comboBox1.dataProvider = new DataProvider(userType); 
			_comboBox1.selectedIndex = 1;
			//_comboBox1.addEventListener(Event.CHANGE, changeHandlerComboBox1); 
			_newWindow.stage.addChild(_comboBox1);
			
			_button1.label = "Сохранить";
			_button1.x = 100; _button1.y = 180;
			_button1.addEventListener(MouseEvent.CLICK, onButton1MouseClick);
			_newWindow.stage.addChild(_button1);
			
			_button2.label = "Отмена";
			_button2.x = 225; _button2.y = 180;
			_button2.addEventListener(MouseEvent.CLICK, onButton2MouseClick);
			_newWindow.stage.addChild(_button2);
		}
		
		private function onButton2MouseClick(e:MouseEvent):void 
		{
			_newWindow.close();
		}
		
		private function onButton1MouseClick(e:MouseEvent):void 
		{
			var sqlCommand:String = "INSERT INTO system_users "
								+ "(system_users_name, system_users_login, system_users_pass, system_users_admin) VALUES ("
								+ "'" + _textBox1.text + "', "
								+ "'" + _textBox2.text + "', "
								+ "'" + _textBox3.text + "', "
								+ "'" + _comboBox1.selectedItem.data + "')";
								
			
			_query = new Query();
			_query.performRequest(Server.serverPath + "system_users_set.php?client=1&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onQueryComplete);
		}
		
		private function onQueryComplete(e:Event):void 
		{
			
			if ((_query.getResult as String) == "complete")
			{
				_newWindow.close();
			}else {
				new MessageBox((_query.getResult as String), "Сообщение");
			}
		}
		
	}

}