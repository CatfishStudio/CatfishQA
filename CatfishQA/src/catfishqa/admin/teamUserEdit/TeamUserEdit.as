package catfishqa.admin.teamUserEdit 
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
	
	import catfishqa.json.JSON;
	import catfishqa.mysql.Query;
	import catfishqa.server.Server;
	import catfishqa.windows.MessageBox;
	
	public class TeamUserEdit extends NativeWindowInitOptions 
	{
		private var _data:Array = [];
		
		private var _newWindow:NativeWindow;
		private var _teamSelect:String;
		
		private var _label1:Label = new Label();
		private var _comboBox1:ComboBox = new ComboBox();
		
		private var _label2:Label = new Label();
		private var _textBox2:TextInput = new TextInput();
		private var _label3:Label = new Label();
		private var _textBox3:TextInput = new TextInput();
		
		private var _label4:Label = new Label();
		private var _comboBox4:ComboBox = new ComboBox();
		
		private var _label5:Label = new Label();
		private var _comboBox5:ComboBox = new ComboBox();
		
		private var _button1:Button = new Button();
		private var _button2:Button = new Button();
		
		private var users:Array = [];
		private var team:Array = [];
		private var rights:Array = new Array( 
			{label:"Чтение", data:"r"},
			{label:"Запись", data:"w"} 
		);
		
		
		private var _query:Query;
		
		public function TeamUserEdit(teamSelect:String, data:Array) 
		{
			super();
			_teamSelect = teamSelect;
			_data = data;
			
			transparent = false; 
			systemChrome = NativeWindowSystemChrome.STANDARD; 
			type = NativeWindowType.NORMAL; 
     
			_newWindow = new NativeWindow(this); 
			_newWindow.title = "Редактировать участника"; 
			_newWindow.width = 350; 
			_newWindow.height = 300; 
			_newWindow.stage.color = 0xDDDDDD;
			_newWindow.alwaysInFront = true; // всегда поверх других окон
			
			_newWindow.stage.align = StageAlign.TOP_LEFT; 
			_newWindow.stage.scaleMode = StageScaleMode.NO_SCALE; 
			_newWindow.activate();
			
			FillUsers();
		}
		
		/* Получить данные с сервера ======================================*/
		private function FillUsers():void
		{
			var sqlCommand:String = "SELECT * FROM system_users";
			
			_query = new Query();
			_query.performRequest(Server.serverPath + "system_users_get.php?client=1&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onFillUsersComplete);
		}
		
		private function onFillUsersComplete(event:Object):void 
		{
			users = [];
			users.push({label: "...", data: null, name: null, login:null});
			
			var json_str:String = (_query.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].user) 
				{
					
					users.push( { 
						label:json_data[i].user[k].system_users_name,
						data:json_data[i].user[k].system_users_id, 
						name:json_data[i].user[k].system_users_name, 
						login:json_data[i].user[k].system_users_login
					} );
				}
			}
			
			FillTeams();
		}
		/* ================================================================*/
		
		/* Получить данные с сервера ======================================*/
		private function FillTeams():void
		{
			var sqlCommand:String = "SELECT * FROM team_groups";
			_query = new Query();
			_query.performRequest(Server.serverPath + "team_groups_get.php?client=1&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onFillTeamsComplete);
		}
		
		private function onFillTeamsComplete(event:Object):void 
		{
			team = [];
			
			var json_str:String = (_query.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].team) 
				{
					
					team.push( { 
						label:json_data[i].team[k].team_groups_name,
						data:json_data[i].team[k].team_groups_id 
					} );
				}
			}
			
			Show();
		}
		/* ================================================================*/
		
		
		private function Show():void
		{
			_label1.text = "Выберите пользователя:"; 
			_label1.x = 10;
			_label1.y = 15;
			_label1.width = 150;
			_newWindow.stage.addChild(_label1);
			
			_comboBox1.x = 150; 
			_comboBox1.y = 10;
			_comboBox1.name = "comboBox1";
			_comboBox1.dropdownWidth = 150; 
			_comboBox1.width = 150;  
			_comboBox1.selectedIndex = 0;
			_comboBox1.dataProvider = new DataProvider(users);
			_comboBox1.addEventListener(Event.CHANGE, onChangeComboBox); 
			_newWindow.stage.addChild(_comboBox1);
			
			_label2.text = "Имя сотрудника:"; 
			_label2.x = 10;
			_label2.y = 50;
			_label2.width = 125;
			_newWindow.stage.addChild(_label2);
			
			_textBox2.text = _data[0].Имя;
			_textBox2.x = 125; 
			_textBox2.y = 50;
			_textBox2.width = 200;
			_newWindow.stage.addChild(_textBox2);
			
			_label3.text = "Логин сотрудника:"; 
			_label3.x = 10;
			_label3.y = 90;
			_label3.width = 125;
			_newWindow.stage.addChild(_label3);
			
			_textBox3.text = _data[0].Логин;
			_textBox3.x = 125; 
			_textBox3.y = 90;
			_textBox3.width = 200;
			_newWindow.stage.addChild(_textBox3);
			
			_label4.text = "Команда:"; 
			_label4.x = 10;
			_label4.y = 130;
			_label4.width = 125;
			_newWindow.stage.addChild(_label4);
			
			_comboBox4.x = 125; 
			_comboBox4.y = 130;
			_comboBox4.name = "comboBox4";
			_comboBox4.dropdownWidth = 200; 
			_comboBox4.width = 200;  
			_comboBox4.selectedIndex = 0;
			_comboBox4.dataProvider = new DataProvider(team); 
			_newWindow.stage.addChild(_comboBox4);
			
			SelectTeam();
			
			_label5.text = "Права:"; 
			_label5.x = 10;
			_label5.y = 170;
			_label5.width = 125;
			_newWindow.stage.addChild(_label5);
			
			_comboBox5.x = 125; 
			_comboBox5.y = 170;
			_comboBox5.name = "comboBox5";
			_comboBox5.dropdownWidth = 200; 
			_comboBox5.width = 200;  
			_comboBox5.selectedIndex = 0;
			_comboBox5.dataProvider = new DataProvider(rights); 
			_newWindow.stage.addChild(_comboBox5);
			
			_button1.label = "Сохранить";
			_button1.x = 100; _button1.y = 220;
			_button1.addEventListener(MouseEvent.CLICK, onButton1MouseClick);
			_newWindow.stage.addChild(_button1);
			
			_button2.label = "Отмена";
			_button2.x = 225; _button2.y = 220;
			_button2.addEventListener(MouseEvent.CLICK, onButton2MouseClick);
			_newWindow.stage.addChild(_button2);
		}
		
		private function SelectTeam():void
		{
			var n:int = team.length;
			for (var i:int = 0; i < n; i++)
			{
				if (team[i].label == _teamSelect)
				{
					_comboBox4.selectedIndex = i;
					break;
				}
			}
		}
		
		private function onChangeComboBox(e:Event):void 
		{
			if ((e.target as ComboBox).name == "comboBox1") 
			{
				if (ComboBox(e.target).selectedItem.label == "...")
				{
					_textBox2.text = "";
					_textBox3.text = "";
				}else{
					_textBox2.text = ComboBox(e.target).selectedItem.name;
					_textBox3.text = ComboBox(e.target).selectedItem.login;
				}
			}
			
		}
		
		
		
		private function onButton1MouseClick(e:MouseEvent):void 
		{
			var sqlCommand:String = "UPDATE team_users SET "
								+ "team_users_name = '" + _textBox2.text + "', "
								+ "team_users_login = '" + _textBox3.text + "', "
								+ "team_users_rights = '" + _comboBox5.selectedItem.data + "', "
								+ "team_users_groups_name = '" + _comboBox4.selectedItem.label + "' "
								+ "WHERE team_users_id = " + _data[0].ID;
			
			_query = new Query();
			_query.performRequest(Server.serverPath + "team_users_set.php?client=1&sqlcommand=" + sqlCommand);
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
		
		private function onButton2MouseClick(e:MouseEvent):void 
		{
			_newWindow.close();
		}
		
	}

}