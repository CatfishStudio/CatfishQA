package catfishqa.admin.teamUserNew 
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
	import catfishqa.json.JSON;
	
	public class TeamUserNew extends NativeWindowInitOptions 
	{
		private var _newWindow:NativeWindow;
		
		private var _label1:Label = new Label();
		private var _comboBox1:ComboBox = new ComboBox();
		
		private var users:Array = [];
		
		
		private var _query:Query;
		
		public function TeamUserNew() 
		{
			super();
			
			transparent = false; 
			systemChrome = NativeWindowSystemChrome.STANDARD; 
			type = NativeWindowType.NORMAL; 
     
			_newWindow = new NativeWindow(this); 
			_newWindow.title = "Новый участник"; 
			_newWindow.width = 350; 
			_newWindow.height = 250; 
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
			_comboBox1.dropdownWidth = 150; 
			_comboBox1.width = 150;  
			_comboBox1.selectedIndex = 0;
			_comboBox1.dataProvider = new DataProvider(users); 
			_newWindow.stage.addChild(_comboBox1);
		}
		
	}

}