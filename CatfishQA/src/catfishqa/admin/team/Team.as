package catfishqa.admin.team 
{
	import fl.controls.DataGrid;
	import fl.data.DataProvider; 
	
	import fl.events.ListEvent;
	
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.controls.listClasses.CellRenderer;
	import fl.controls.ScrollPolicy;
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.controls.List;
	
	import flash.display.NativeWindow; 
	import flash.display.NativeWindowDisplayState;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.events.NativeWindowBoundsEvent;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.display.Bitmap;
	
	import flash.utils.Timer;
	import flash.events.TimerEvent; 
	
	import catfishqa.mysql.Query;
	import catfishqa.server.Server;
	import catfishqa.server.ServerEvents;
	import catfishqa.resource.Resource;
	import catfishqa.json.JSON;
	import catfishqa.admin.team.teamGroupsNew.TempGroupNew;
	import catfishqa.admin.team.teamGroupsEdit.TeamGroupEdit;
	import catfishqa.admin.team.teamGroupsRemove.TeamGroupRemove;
	import catfishqa.admin.buttons.ButtonCellEdit;
	import catfishqa.admin.buttons.ButtonCellDelete;
	import catfishqa.admin.team.teamUserNew.TeamUserNew;
	import catfishqa.admin.team.teamUserEdit.TeamUserEdit;
	import catfishqa.admin.team.teamUserRemove.TeamUserRemove;
	import catfishqa.windows.htmlPage;
	
	public class Team extends NativeWindowInitOptions 
	{
		private var _newWindow:NativeWindow;
		private var _timer:Timer = new Timer(2000, 1);
		
		private var _tempGroupsArray:Array = [];
		private var _tempUsersArray:Array = [];
		private var _tempGroupsSelectID:int = 0;
		private var _tempGroupsSelectName:String = "";
		private var _tempGroupsSelectLink:String = "";
		
		private var _label1:Label;
		private var _list:List;
		private var _button1:Button;
		private var _button2:Button;
		private var _button3:Button;
		
		private var _buttonAdd:Button = new Button();
		private var _dataGrid:DataGrid;
		
		public function Team() 
		{
			super();
			
			transparent = false; 
			systemChrome = NativeWindowSystemChrome.STANDARD; 
			type = NativeWindowType.NORMAL; 
     
			_newWindow = new NativeWindow(this); 
			_newWindow.title = "Проекты и команды"; 
			_newWindow.width = 900; 
			_newWindow.height = 560; 
			_newWindow.stage.color = 0xA8ABC6;
			_newWindow.alwaysInFront = true; // всегда поверх других окон
			
			_newWindow.stage.align = StageAlign.TOP_LEFT; 
			_newWindow.stage.scaleMode = StageScaleMode.NO_SCALE; 
			_newWindow.activate();
			
			_newWindow.addEventListener(Event.CLOSE, onClose);
			_newWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, onResize);
			
			Server.addEventListener(ServerEvents.TABLE_UPDATE, onServerEvents);
			
			QueryTeamGroupsSelect();
		}
		
		private function onClose(e:Event):void 
		{
			_timer.stop();
			_timer = null;
			Server.removeEventListener(ServerEvents.TABLE_UPDATE, onServerEvents);
		}
		
		private function onResize(e:NativeWindowBoundsEvent):void 
		{
			_list.setSize(225, _newWindow.height - 110);
			_dataGrid.setSize(_newWindow.width - 265, _newWindow.height - 110);
		}
		
		
		private function onServerEvents(event:ServerEvents):void 
		{
			switch(event.param.id)
			{
				case Server.TEAM_GROUPS_UPDATE: 
				{
					UpdateList();
					break;
				}
				
				case Server.TEAM_GROUPS_NOT_UPDATE: 
				{
					_timer.start();
					break;
				}
				
				case Server.TEAM_USERS_UPDATE: 
				{
					UpdateDataGrid();
					break;
				}
				
				case Server.TEAM_USERS_NOT_UPDATE: 
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
		
		
		/* =================================================================
		 * 
		 *  ЛИСТ
		 * 
		 * ================================================================*/
		
		/* Получить данные с сервера ======================================*/
		private function QueryTeamGroupsSelect():void
		{
			var _query:Query;
			var sqlCommand:String = "SELECT * FROM team_groups";
			
			_query = new Query();
			_query.performRequest(Server.serverPath + "team_groups_get.php?client=1&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onQueryTeamGroupComplete);
		}
		
		private function onQueryTeamGroupComplete(event:Object):void 
		{
			_tempGroupsArray = [];
			
			var json_str:String = (event.target.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].team) 
				{
					_tempGroupsArray.push( { 
					//iconSource:,
					label:json_data[i].team[k].team_groups_name,
					ID:json_data[i].team[k].team_groups_id,
					Link:json_data[i].team[k].team_groups_link_project
					} );
					
				}
			}
			groupShow();
		}
		/* ================================================================*/
		
		
		/* КОМАНДА ГРУППЫ ФОРМА ===========================================*/
		private function groupShow():void
		{
			var bGroupIcon:Bitmap = new Resource.ImageGroupUserIcon();
			bGroupIcon.x = 10;
			bGroupIcon.y = 5;
			_newWindow.stage.addChild(bGroupIcon);
			
			_label1 = new Label();
			_label1.text = "Проект: "; 
			_label1.x = 30;
			_label1.y = 5;
			_label1.width = 250;
			_label1.height = 20;
			_label1.setStyle("textFormat", new TextFormat("Arial", 12, 0xffffff));
			_newWindow.stage.addChild(_label1);
			
			_button1 = new Button();
			_button1.label = "Добавить";
			_button1.x = 10; 
			_button1.y = 30;
			_button1.width = 70;
			_button1.addEventListener(MouseEvent.CLICK, onButton1Click);
			_newWindow.stage.addChild(_button1);
			
			_button2 = new Button();
			_button2.label = "Изменить";
			_button2.x = 85; 
			_button2.y = 30;
			_button2.width = 70;
			_button2.addEventListener(MouseEvent.CLICK, onButton2Click);
			_newWindow.stage.addChild(_button2);
			
			_button3 = new Button();
			_button3.label = "Удалить";
			_button3.x = 160; 
			_button3.y = 30;
			_button3.width = 70;
			_button3.addEventListener(MouseEvent.CLICK, onButton3Click);
			_newWindow.stage.addChild(_button3);
			
			CreateList();
		}
		
		private function CreateList():void
		{
			_list = new List();
			_list.addEventListener(ListEvent.ITEM_CLICK, onListClick);
			_list.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, onListDoubleClick);
			_list.setSize(225, _newWindow.height - 110); 
			_list.move(10, 60);
			_list.rowHeight = 20;
			_list.selectable = false;
			_list.verticalScrollPolicy = ScrollPolicy.ON;
			_list.dataProvider = new DataProvider(_tempGroupsArray);
			_newWindow.stage.addChild(_list);
			
			
			if (_list.dataProvider.length > 0)
			{
				_tempGroupsSelectID = _list.dataProvider.getItemAt(_list.dataProvider.length - 1).ID;
				_tempGroupsSelectName = _list.dataProvider.getItemAt(_list.dataProvider.length - 1).label;
				_tempGroupsSelectLink = _list.dataProvider.getItemAt(_list.dataProvider.length - 1).Link;
			}else {
				_tempGroupsSelectID = 0;
				_tempGroupsSelectName = "";
				_tempGroupsSelectLink = "";
			}
			_label1.text = "Проект: " + _tempGroupsSelectName;
			
			QueryTeamUsersSelect();
		}
		
		private function UpdateList():void
		{
			_timer.stop();
			var _query:Query;
			var sqlCommand:String = "SELECT * FROM team_groups";
			_query = new Query();
			_query.performRequest(Server.serverPath + "team_groups_get.php?client=1&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onUpdateListComplete);
		}
		
		private function onUpdateListComplete(event:Event):void 
		{
			_tempGroupsArray = [];
			var json_str:String = (event.target.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].team) 
				{
					_tempGroupsArray.push( { 
						label:json_data[i].team[k].team_groups_name,
						ID:json_data[i].team[k].team_groups_id,
						Link:json_data[i].team[k].team_groups_link_project
					} );
				}
			}
			_list.dataProvider = new DataProvider(_tempGroupsArray);
			
			if (checkSelectGroup() == false)
			{
				_tempGroupsSelectID = 0;
				_tempGroupsSelectName = "";
				_tempGroupsSelectLink = "";
			}
			_label1.text = "Проект: " + _tempGroupsSelectName;
			_timer.start();
		}
		
		private function checkSelectGroup():Boolean
		{
			var n:int = _list.dataProvider.length;
			for ( var i:int = 0; i < n; i++)
			{
				if (_tempGroupsSelectName == _list.dataProvider.getItemAt(i).label)
				{
					return true;
				}
			}
			return false;
		}
		
		private function onButton1Click(e:MouseEvent):void 
		{
			if (Resource.myStatus == Resource.ADMIN) new TempGroupNew();
		}
		
		private function onButton2Click(e:MouseEvent):void 
		{
			if (Resource.myStatus == Resource.ADMIN && _tempGroupsSelectName != "")
			{
				var data:Array = [];
				data.push({
					ID:_tempGroupsSelectID, 
					Name:_tempGroupsSelectName,
					Link:_tempGroupsSelectLink
				});
				new TeamGroupEdit(data);
			}
		}
		
		private function onButton3Click(e:MouseEvent):void 
		{
			if (Resource.myStatus == Resource.ADMIN && _tempGroupsSelectName != "") new TeamGroupRemove(_tempGroupsSelectID.toString(), _tempGroupsSelectName);
		}
		
		private function onListClick(e:ListEvent):void 
		{
			var list:List = e.target as List;
			_tempGroupsSelectID = list.dataProvider.getItemAt(e.index).ID;
			_tempGroupsSelectName = list.dataProvider.getItemAt(e.index).label;
			_tempGroupsSelectLink = list.dataProvider.getItemAt(e.index).Link;
			_label1.text = "Проект: " + _tempGroupsSelectName;
			UpdateDataGrid();
		}
		
		private function onListDoubleClick(e:ListEvent):void 
		{
			var list:List = e.target as List;
			_tempGroupsSelectID = list.dataProvider.getItemAt(e.index).ID;
			_tempGroupsSelectName = list.dataProvider.getItemAt(e.index).label;
			_tempGroupsSelectLink = list.dataProvider.getItemAt(e.index).Link;
			_label1.text = "Проект: " + _tempGroupsSelectName;
			new htmlPage(_tempGroupsSelectLink);
		}
		/* ================================================================*/
		
		
		/* ================================================================
		 * 
		 *  ТАБЛИЦА
		 * 
		 * ================================================================*/
		
		
		/* Получить данные с сервера ======================================*/
		private function QueryTeamUsersSelect():void
		{
			var _query:Query;
			var sqlCommand:String = "SELECT * FROM team_users WHERE team_users_groups_name = '" + _tempGroupsSelectName + "'";
			_query = new Query();
			_query.performRequest(Server.serverPath + "team_users_get.php?client=1&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onQueryTeamUserComplete);
		}
		
		private function onQueryTeamUserComplete(event:Object):void 
		{
			_tempUsersArray = [];
			
			var json_str:String = (event.target.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].team) 
				{
					_tempUsersArray.push( { 
						//Icon: (IconCell),
						N:i+1,
						ID:json_data[i].team[k].team_users_id,
						Имя:json_data[i].team[k].team_users_name,
						Логин:json_data[i].team[k].team_users_login,
						Права:json_data[i].team[k].team_users_rights == "r" ? "Чтение" : "Запись",
						Изменить: (ButtonCellEdit),
						Удалить: (ButtonCellDelete),
						Команда:json_data[i].team[k].team_users_groups_name 
					} );
					
				}
			}
		
			ButtonAdd();
			CreateDataGrid();
		}
		/* ================================================================*/
		
		/* Кнопка =================================================================*/
		private function ButtonAdd():void
		{
			var buserIcon:Bitmap = new Resource.ImageUserIcon();
			buserIcon.x = 245;
			buserIcon.y = 35;
			_newWindow.stage.addChild(buserIcon);
			
			_buttonAdd.label = "Добавить в команду";
			_buttonAdd.x = 270; 
			_buttonAdd.y = 30;
			_buttonAdd.width = 150;
			_buttonAdd.addEventListener(MouseEvent.CLICK, onButtonAddMouseClick);
			_newWindow.stage.addChild(_buttonAdd);
		}
		
		private function onButtonAddMouseClick(e:MouseEvent):void 
		{
			if (Resource.myStatus == Resource.ADMIN && _tempGroupsSelectName != "")
			{
				new TeamUserNew(_tempGroupsSelectName);
			}
		}
		/* ================================================================*/
		
		/* ТАБЛИЦА СОТРУДНИКОВ КОМАНДЫ ====================================*/
		private function CreateDataGrid():void
		{
			_dataGrid = new DataGrid();
			
			_dataGrid.addEventListener(ListEvent.ITEM_CLICK, onDataGridClick);
			
			_dataGrid.columns = [ "...", "N", "Имя", "Логин", "Права", "Изменить", "Удалить", "..."];
			
			var indexCellButton:Number = _dataGrid.getColumnIndex("Изменить");
            _dataGrid.getColumnAt(indexCellButton).cellRenderer = ButtonCellEdit;
			indexCellButton = _dataGrid.getColumnIndex("Удалить");
            _dataGrid.getColumnAt(indexCellButton).cellRenderer = ButtonCellDelete;
           	
			
			_dataGrid.dataProvider = new DataProvider(_tempUsersArray); 
			
			_dataGrid.setSize(_newWindow.width - 265, _newWindow.height - 110);
			_dataGrid.move(240, 60);
			_dataGrid.rowHeight = 20;
			
			_dataGrid.columns[0].width = 25;
			_dataGrid.columns[1].width = 50;
			_dataGrid.columns[2].width = 150;
			_dataGrid.columns[3].width = 150;
			_dataGrid.columns[4].width = 100;
			_dataGrid.columns[5].width = 80;
			_dataGrid.columns[6].width = 80;
			
			_dataGrid.resizableColumns = true; 
			_dataGrid.selectable = false;
			_dataGrid.editable = false;
			
			
			_dataGrid.verticalScrollPolicy = ScrollPolicy.AUTO; // полоса прокрутки
			_dataGrid.horizontalScrollPolicy = ScrollPolicy.AUTO; // полоса прокрутки
			
			_newWindow.stage.addChild(_dataGrid);
			
			TimerStart();
		}
		
		private function UpdateDataGrid():void
		{
			_timer.stop();
			var _query:Query;
			var sqlCommand:String = "SELECT * FROM team_users WHERE team_users_groups_name = '" + _tempGroupsSelectName + "'";
			_query = new Query();
			_query.performRequest(Server.serverPath + "team_users_get.php?client=1&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onUpdateDataGridComplete);
		}
		
		private function onUpdateDataGridComplete(event:Event):void 
		{
			_tempUsersArray = [];
			
			var json_str:String = (event.target.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].team) 
				{
					_tempUsersArray.push( { 
						//Icon: (IconCell),
						N:i+1,
						ID:json_data[i].team[k].team_users_id,
						Имя:json_data[i].team[k].team_users_name,
						Логин:json_data[i].team[k].team_users_login,
						Права:json_data[i].team[k].team_users_rights == "r" ? "Чтение" : "Запись",
						Изменить: (ButtonCellEdit),
						Удалить: (ButtonCellDelete),
						Команда:json_data[i].team[k].team_users_groups_name  
					} );
					
				}
			}
			
			_dataGrid.dataProvider = new DataProvider(_tempUsersArray);
			_timer.start();
		}
		
		private function onDataGridClick(e:ListEvent):void 
		{
			var dg:DataGrid = e.target as DataGrid;
			if (Resource.myStatus == Resource.ADMIN)
			{
				if (dg.columns[e.columnIndex].headerText == "Изменить")
				{
					var data:Array = [];
					data.push({
						ID:dg.dataProvider.getItemAt(e.index).ID, 
						Имя:dg.dataProvider.getItemAt(e.index).Имя, 
						Логин:dg.dataProvider.getItemAt(e.index).Логин,
						Права:dg.dataProvider.getItemAt(e.index).Права == "Чтение" ? "r" : "w",
						Команда:dg.dataProvider.getItemAt(e.index).Команда
					});
					new TeamUserEdit(_tempGroupsSelectName, data);
				}
				if (dg.columns[e.columnIndex].headerText == "Удалить")
				{
					new TeamUserRemove(dg.dataProvider.getItemAt(e.index).ID, _tempGroupsSelectName, dg.dataProvider.getItemAt(e.index).Имя);
				}
			}
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
			Server.checkTableUpdate(Server.TEAM_GROUPS);
			Server.checkTableUpdate(Server.TEAM_USERS);
		} 
		/* ================================================================*/
	}

}