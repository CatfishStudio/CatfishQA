package catfishqa.admin.systemUsers 
{
	import fl.controls.DataGrid;
	import fl.data.DataProvider; 
	
	import fl.events.ListEvent;
	
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
	
	import catfishqa.mysql.Query;
	import catfishqa.server.Server;
	import catfishqa.server.ServerEvents;
	import catfishqa.resource.Resource;
	import catfishqa.json.JSON;
	
	import catfishqa.admin.systemUsers.ButtonCellEdit;
	import catfishqa.admin.systemUsers.ButtonCellDelete;
	
	import catfishqa.admin.systemUserNew.SystemUserNew;
	import catfishqa.admin.systemUserEdit.SystemUserEdit;
	import catfishqa.admin.systemUserRemove.SystemUserRemove;
	
	public class SystemUser extends NativeWindowInitOptions 
	{
		private var _newWindow:NativeWindow;
		private var _dataGrid:DataGrid;
		private var _button:Button = new Button();
		
		private var _query:Query;
		private var _timer:Timer = new Timer(2000, 1);
		
		public var systemUsersArray:Array = []; // Таблица базы данных system_users
		
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
			
			QuerySelect(); // Запрос к базе данных с дальнейшим созданием таблицы DataGrid
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
			new SystemUserNew();
		}
		/* ================================================================*/
		
		/* Получить данные с сервера ======================================*/
		private function QuerySelect():void
		{
			_query = new Query();
			_query.performRequest(Server.serverPath + "system_users_select.php?client=1");
			_query.addEventListener("complete", onQueryComplete);
		}
		
		private function onQueryComplete(event:Object):void 
		{
			systemUsersArray = [];
			
			var json_str:String = (_query.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].user) 
				{
					systemUsersArray.push( { 
					N:i+1,
					ID:json_data[i].user[k].system_users_id, 
					Имя:json_data[i].user[k].system_users_name, 
					Логин:json_data[i].user[k].system_users_login,
					Пароль:json_data[i].user[k].system_users_pass,
					Администратор:json_data[i].user[k].system_users_admin == 1 ? "Да" : "Нет",
					Изменить: (ButtonCellEdit),
					Удалить: (ButtonCellDelete)
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
			
			_dataGrid.addEventListener(ListEvent.ITEM_CLICK, onClick);
			
			_dataGrid.columns = [ "N", "Имя", "Логин", "Пароль", "Администратор", "Изменить", "Удалить"];
			
			var indexCellButton:Number = _dataGrid.getColumnIndex("Изменить");
            _dataGrid.getColumnAt(indexCellButton).cellRenderer = ButtonCellEdit;
			indexCellButton = _dataGrid.getColumnIndex("Удалить");
            _dataGrid.getColumnAt(indexCellButton).cellRenderer = ButtonCellDelete;
           	
			
			_dataGrid.dataProvider = new DataProvider(systemUsersArray); 
			
			_dataGrid.setSize(650, 300);
			_dataGrid.move(10, 40);
			_dataGrid.rowHeight = 20;
			
			_dataGrid.columns[0].width = 25;
			_dataGrid.columns[1].width = 200;
			_dataGrid.columns[2].width = 150;
			_dataGrid.columns[3].width = 50;
			_dataGrid.columns[4].width = 50;
			_dataGrid.columns[5].width = 80;
			_dataGrid.columns[6].width = 80;
			
			_dataGrid.resizableColumns = true; 
			_dataGrid.selectable = false;
			_dataGrid.editable = false;
			
			
			_dataGrid.verticalScrollPolicy = ScrollPolicy.AUTO; // полоса прокрутки
			_dataGrid.horizontalScrollPolicy = ScrollPolicy.AUTO; // полоса прокрутки
			//_dataGrid.rowCount = _dataGrid.length;
			
			/*
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
			*/
			
			_newWindow.stage.addChild(_dataGrid);
			
			TimerStart();
		}
		
		private function onClick(e:ListEvent):void 
		{
			var dg:DataGrid = e.target as DataGrid;
			////////////////////trace(dg1.getColumnAt(dg1.getColumnIndex('ID')).dataField);
			//trace(dg.columns[e.columnIndex].headerText);
			//trace(dg.dataProvider.getItemAt(e.index).ID);
			
			if (Resource.myStatus == Resource.ADMIN)
			{
				if (dg.columns[e.columnIndex].headerText == "Изменить")
				{
					var data:Array = [];
					data.push({
						ID:dg.dataProvider.getItemAt(e.index).ID, 
						Имя:dg.dataProvider.getItemAt(e.index).Имя, 
						Логин:dg.dataProvider.getItemAt(e.index).Логин,
						Пароль:dg.dataProvider.getItemAt(e.index).Пароль,
						Администратор:dg.dataProvider.getItemAt(e.index).Администратор == "Да" ? "1" : "0"
					});
					new SystemUserEdit(data);
				}
				if (dg.columns[e.columnIndex].headerText == "Удалить")
				{
					new SystemUserRemove(dg.dataProvider.getItemAt(e.index).ID);
				}
			}
		}
		/* ================================================================*/
		
		
		/* ОБНОВЛЕНИЕ DATAGRID (получаем обновленные данные с сервера) === */
		private function UpdateDataGrid():void
		{
			_query = new Query();
			_query.performRequest(Server.serverPath + "system_users_select.php?client=1");
			_query.addEventListener("complete", onUpdateDataGridComplete);
		}
		
		private function onUpdateDataGridComplete(e:Event):void 
		{
			systemUsersArray = [];
			
			var json_str:String = (_query.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].user) 
				{
					systemUsersArray.push( { 
					N:i+1,
					ID:json_data[i].user[k].system_users_id, 
					Имя:json_data[i].user[k].system_users_name, 
					Логин:json_data[i].user[k].system_users_login,
					Пароль:json_data[i].user[k].system_users_pass,
					Администратор:json_data[i].user[k].system_users_admin == 1 ? "Да" : "Нет",
					Изменить: (ButtonCellEdit),
					Удалить: (ButtonCellDelete)
					} );
				}
			}
			
			_dataGrid.dataProvider = new DataProvider(systemUsersArray);
			
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