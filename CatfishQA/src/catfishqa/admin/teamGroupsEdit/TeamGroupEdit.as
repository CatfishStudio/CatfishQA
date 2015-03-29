package catfishqa.admin.teamGroupsEdit 
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
	
	public class TeamGroupEdit extends NativeWindowInitOptions 
	{
		private var _data:Array = [];
		
		private var _newWindow:NativeWindow;
		private var _label1:Label;
		private var _textBox1:TextInput;
		
		private var _button1:Button;
		private var _button2:Button;
		
		private var _query:Query;
		
		public function TeamGroupEdit(data:Array) 
		{
			super();
			_data = data;
			
			transparent = false; 
			systemChrome = NativeWindowSystemChrome.STANDARD; 
			type = NativeWindowType.NORMAL; 
     
			_newWindow = new NativeWindow(this); 
			_newWindow.title = "Редактировать группу"; 
			_newWindow.width = 350; 
			_newWindow.height = 150; 
			_newWindow.stage.color = 0xDDDDDD;
			_newWindow.alwaysInFront = true; // всегда поверх других окон
			
			_newWindow.stage.align = StageAlign.TOP_LEFT; 
			_newWindow.stage.scaleMode = StageScaleMode.NO_SCALE; 
			_newWindow.activate();
			
			Show();
		}
		
		private function Show():void
		{
			_label1 = new Label();
			_label1.text = "Имя группы:"; 
			_label1.x = 10;
			_label1.y = 10;
			_label1.width = 125;
			_newWindow.stage.addChild(_label1);
			
			_textBox1 = new TextInput();
			_textBox1.text = _data[0].Name;
			_textBox1.x = 125; 
			_textBox1.y = 10;
			_textBox1.width = 200;
			_newWindow.stage.addChild(_textBox1);
			
			_button1 = new Button();
			_button1.label = "Сохранить";
			_button1.x = 100; _button1.y = 80;
			_button1.addEventListener(MouseEvent.CLICK, onButton1MouseClick);
			_newWindow.stage.addChild(_button1);
			
			_button2 = new Button();
			_button2.label = "Отмена";
			_button2.x = 225; _button2.y = 80;
			_button2.addEventListener(MouseEvent.CLICK, onButton2MouseClick);
			_newWindow.stage.addChild(_button2);
		}
		
		private function onButton1MouseClick(e:MouseEvent):void 
		{
			var sqlCommand:String = "UPDATE team_groups SET "
								+ "team_groups_name = '" + _textBox1.text + "' "
								+ "WHERE team_groups_id = " + _data[0].ID;
			
			_query = new Query();
			_query.performRequest(Server.serverPath + "team_groups_set.php?client=1&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onQuery1Complete);
		}
		
		private function onQuery1Complete(e:Event):void 
		{
			
			if ((_query.getResult as String) == "complete")
			{
				var sqlCommand:String = "UPDATE team_users SET "
								+ "team_users_groups_name = '" + _textBox1.text + "' "
								+ "WHERE team_users_groups_name = '" + _data[0].Name + "'";
			
				_query = new Query();
				_query.performRequest(Server.serverPath + "team_users_set.php?client=1&sqlcommand=" + sqlCommand);
				_query.addEventListener("complete", onQuery2Complete);
			}else {
				new MessageBox((_query.getResult as String), "Сообщение");
			}
		}
		
		private function onQuery2Complete(e:Event):void 
		{
			
			if ((_query.getResult as String) == "complete")
			{
				_newWindow.close();
			}else {
				new MessageBox((_query.getResult as String), "Сообщение");
			}
		}
		
		private function onButton2MouseClick(e:MouseEvent):void 
		{
			_newWindow.close();
		}
		
	}

}