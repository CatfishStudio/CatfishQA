package catfishqa.systemUsers 
{
	import fl.controls.DataGrid;
	import fl.controls.ScrollBar;
	import fl.data.DataProvider; 
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.controls.listClasses.CellRenderer;
	import fl.controls.ScrollPolicy;
	import fl.controls.Button;
	
	import flash.display.NativeWindow; 
	import flash.display.NativeWindowDisplayState;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.utils.Timer;
	import flash.events.TimerEvent; 
	
	//import flash.net.URLRequest;
	
	import catfishqa.mysql.Query;
	import catfishqa.resource.Resource;
	import catfishqa.server.Server;
	import catfishqa.server.ServerEvents;
	import catfishqa.json.JSON;
	//import catfishqa.events.Navigation;
	
	import catfishqa.systemUsers.ButtonCellEdit;
	import catfishqa.systemUsers.ButtonCellDelete;
	
	
	public class SystemUser extends NativeWindowInitOptions 
	{
		private var _newWindow:NativeWindow;
		private var _dataGrid:DataGrid;
		private var _button:Button = new Button();
		
		private var _query:Query;
		private var _timer:Timer = new Timer(5000, 1);
		
		
		public function SystemUser() 
		{
			super();
			
			transparent = false; 
			systemChrome = NativeWindowSystemChrome.STANDARD; 
			type = NativeWindowType.NORMAL; 
     
			_newWindow = new NativeWindow(this); 
			_newWindow.title = "Системные пользователи"; 
			_newWindow.width = 700; 
			_newWindow.height = 400; 
			_newWindow.stage.color = 0xDDDDDD;
			_newWindow.alwaysInFront = true; // всегда поверх других окон
			
			_newWindow.stage.align = StageAlign.TOP_LEFT; 
			_newWindow.stage.scaleMode = StageScaleMode.NO_SCALE; 
			_newWindow.activate();
			
			_newWindow.addEventListener(Event.CLOSE, onClose);
			
			Server.addEventListener(ServerEvents.TABLE_UPDATE, onServerEvents);
			
			ButtonAdd(); // Создать кнопку "добавить пользователя"
			
			QueryInDataBase(); // Запрос к базе данных с дальнейшим созданием таблицы DataGrid
		}
		
		private function onClose(e:Event):void 
		{
			_timer.stop();
			_timer = null;
			Server.removeEventListener(ServerEvents.TABLE_UPDATE, onServerEvents);
		}
		
		private function onServerEvents(event:ServerEvents):void 
		{
			switch(event.param.id)
			{
				case Server.SYSTEM_USERS_UPDATE: 
				{
					UpdateDataGrid();
					break;
				}
				
				case Server.SYSTEM_USERS_NOT_UPDATE: 
				{
					_timer.start();
					break;
				}
				
				default:
				{
					break;
				}

			}
		}
		
		/* Кнопка =================================================================*/
		private function ButtonAdd():void
		{
			_button.label = "Добавить пользователя";
			_button.x = 10; _button.y = 10;
			_button.width = 200;
			_button.addEventListener(MouseEvent.CLICK, onButtonMouseClick);
			_newWindow.stage.addChild(_button);
		}
		
		private function onButtonMouseClick(e:MouseEvent):void 
		{
			_newWindow.close();
		}
		/* ================================================================*/
		
		/* Получить данные с сервера ======================================*/
		private function QueryInDataBase():void
		{
			_query = new Query();
			_query.performRequest(Server.serverPath + "system_users_get.php?client=1");
			_query.addEventListener("complete", onQueryComplete);
		}
		
		private function onQueryComplete(event:Object):void 
		{
			Server.systemUsersArray = [];
			
			var json_str:String = (_query.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].user) 
				{
					Server.systemUsersArray.push( { ID:json_data[i].user[k].system_users_id, 
					Имя:json_data[i].user[k].system_users_name, 
					Логин:json_data[i].user[k].system_users_login,
					Пароль:json_data[i].user[k].system_users_pass,
					Администратор:json_data[i].user[k].system_users_admin
					} );
				}
			}

			CreateDataGrid(); // Создаем на форме таблицу DataGrid
		}
		/* ================================================================*/
		
		
		/* Таблица DataGrid ===============================================*/
		private function CreateDataGrid():void
		{
			_dataGrid = new DataGrid();
			
			_dataGrid.dataProvider = new DataProvider(Server.systemUsersArray); 
			
			_dataGrid.columns = [ "ID", "Имя", "Логин", "Пароль", "Администратор"];
			_dataGrid.setSize(650, 300);
			_dataGrid.move(10, 40);
			_dataGrid.rowHeight = 20;
			
			_dataGrid.columns[0].width = 25;
			_dataGrid.columns[1].width = 200;
			_dataGrid.columns[2].width = 150;
			_dataGrid.columns[3].width = 50;
			_dataGrid.columns[4].width = 50;
			
			
			_dataGrid.resizableColumns = true; 
			_dataGrid.selectable = false;
			_dataGrid.editable = false;
			
			
			_dataGrid.verticalScrollPolicy = ScrollPolicy.AUTO; // полоса прокрутки
			_dataGrid.horizontalScrollPolicy = ScrollPolicy.AUTO; // полоса прокрутки
			//_dataGrid.rowCount = _dataGrid.length;
				
			var btnCol:DataGridColumn = new DataGridColumn("...");
			btnCol.cellRenderer = ButtonCellEdit;
			btnCol.editable = false;
			_dataGrid.addColumn(btnCol);
			_dataGrid.columns[5].width = 80;
			
			btnCol = new DataGridColumn("....");
			btnCol.cellRenderer = ButtonCellDelete;
			btnCol.editable = false;
			_dataGrid.addColumn(btnCol);
			_dataGrid.columns[6].width = 80;
			
			_newWindow.stage.addChild(_dataGrid);
			
			TimerStart();
		}
		/* ================================================================*/
		
		
		/* ОБНОВЛЕНИЕ DATAGRID (получаем обновленные данные с сервера) === */
		private function UpdateDataGrid():void
		{
			_query = new Query();
			_query.performRequest(Server.serverPath + "system_users_get.php?client=1");
			_query.addEventListener("complete", onUpdateDataGridComplete);
		}
		
		private function onUpdateDataGridComplete(e:Event):void 
		{
			Server.systemUsersArray = [];
			
			var json_str:String = (_query.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].user) 
				{
					Server.systemUsersArray.push( { ID:json_data[i].user[k].system_users_id, 
					Имя:json_data[i].user[k].system_users_name, 
					Логин:json_data[i].user[k].system_users_login,
					Пароль:json_data[i].user[k].system_users_pass,
					Администратор:json_data[i].user[k].system_users_admin
					} );
				}
			}
			
			_dataGrid.dataProvider = new DataProvider(Server.systemUsersArray);
			
			_timer.start();
		}
		/* ================================================================*/
		
		
		/* ТАЙМЕР (запрос к серверу на получение обновлённых данных) ======*/
		private function TimerStart():void
		{
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
            _timer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
            _timer.start();
		}
				
		private function timerHandler(e:TimerEvent):void
		{
			//...
		}

		private function completeHandler(e:TimerEvent):void
		{
			Server.checkTableUpdate(Server.SYSTEM_USERS);
		} 
		/* ================================================================*/
		
		
		
	}

}