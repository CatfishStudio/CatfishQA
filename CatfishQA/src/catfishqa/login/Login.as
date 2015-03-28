package catfishqa.login 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import fl.controls.Button;
	import fl.controls.TextInput;
	import fl.controls.ComboBox;
	import fl.controls.Label;
	import fl.data.DataProvider; 
	import fl.events.ComponentEvent;
	
	import catfishqa.mysql.Query;
	import catfishqa.resource.Resource;
	import catfishqa.server.Server;
	import catfishqa.json.JSON;
	import catfishqa.events.Navigation;
	import catfishqa.windows.MessageBox;
	
	/**
	 * ...
	 * @author Catfish Studio Games
	 */
	
	public class Login extends Sprite 
	{
		private var _label1:Label = new Label();
		private var _label2:Label = new Label();
		private var _textBox1:TextInput = new TextInput();
		private var _label3:Label = new Label();
		private var _comboBox1:ComboBox = new ComboBox();
		private var _button1:Button = new Button();
		private var _button2:Button = new Button();
		
		private var _query:Query;
		
		/*
		private var LevelType:Array = new Array( 
			{label:"All", data:"LEVEL_TYPE_ALL"},
			{label:"Tournament", data:"LEVEL_TYPE_TOURNAMENT"}, 
			{label:"Player sv Player", data:"LEVEL_TYPE_PVP"}
		);*/ 
		
		private var usersArray:Array = []; 
		private var selectUserLogin:String;
		private var selectUserPass:String;
		private var selectUserAdmin:String;
		
		public function Login() 
		{
			super();
			name = Resource.LOGIN;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			var sqlCommand:String = "SELECT * FROM system_users";
			
			_query = new Query();
			_query.performRequest(Server.serverPath + "system_users_get.php?client=1&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onQueryComplete);
		}
		
		private function onQueryComplete(event:Object):void 
		{
			//trace(_query.getResult);
			
			var json_str:String = (_query.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].user) 
				{
					//trace(json_data[i].user[k].system_users_name);
					//usersArray.push( { system_users_login:json_data[i].user[k].system_users_name, system_users_login:json_data[i].user[k].system_users_login, system_users_pass:json_data[i].user[k].system_users_pass,  system_users_admin:json_data[i].user[k].system_users_admin } );
					//trace(usersArray[i].system_users_login);
					
					usersArray.push( { label:json_data[i].user[k].system_users_login, data:json_data[i].user[k].system_users_pass, status:json_data[i].user[k].system_users_admin} );
				}
			}

			selectUserLogin = usersArray[0].label;
			selectUserPass = usersArray[0].data;
			selectUserAdmin = usersArray[0].status;
			
			loginShow();
		}


		
		private function loginShow():void
		{
			_label1.text = "Инициализация:"; 
			_label1.x = 10;
			_label1.y = 110;
			addChild(_label1);
			
			
			_label2.text = "Логин:"; 
			_label2.x = 10;
			_label2.y = 140;
			addChild(_label2);
			
			_comboBox1.x = 60; _comboBox1.y = 140;
			_comboBox1.dropdownWidth = 210; 
			_comboBox1.width = 200;  
			_comboBox1.selectedIndex = 0;
			_comboBox1.dataProvider = new DataProvider(usersArray); 
			_comboBox1.addEventListener(Event.CHANGE, changeHandlerComboBox1); 
			addChild(_comboBox1);
			
			_label3.text = "Пароль:"; 
			_label3.x = 10;
			_label3.y = 180;
			addChild(_label3);
			
			_textBox1.text = "";
			_textBox1.x = 60; _textBox1.y = 180;
			_textBox1.width = 200;
			_textBox1.displayAsPassword = true;
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
			if (selectUserLogin == _comboBox1.text && selectUserPass == _textBox1.text)
			{
				if (selectUserAdmin == "1") dispatchEvent(new Navigation(Navigation.CHANGE_SCREEN, { id: Resource.ADMIN }, true));
				else dispatchEvent(new Navigation(Navigation.CHANGE_SCREEN, { id: Resource.CLIENT }, true));
			}else {
				new MessageBox("Ошибка!!! Вы ввели не верный пароль!", "Сообщение");
			}
		}
		
		private function onButton2MouseClick(e:MouseEvent):void 
		{
			_comboBox1.selectedIndex = 0;
			selectUserLogin = usersArray[0].label;
			selectUserPass = usersArray[0].data;
			selectUserAdmin = usersArray[0].status;
			_textBox1.text = "";
		}
		
		private function changeHandlerComboBox1(e:Event):void 
		{
			_comboBox1.text = ComboBox(e.target).selectedItem.label;
			selectUserLogin = ComboBox(e.target).selectedItem.label;
			selectUserPass = ComboBox(e.target).selectedItem.data;
			selectUserAdmin = ComboBox(e.target).selectedItem.status;
		}
		
		
	}

}