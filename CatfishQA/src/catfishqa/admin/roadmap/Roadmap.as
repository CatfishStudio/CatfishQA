package catfishqa.admin.roadmap 
{
	import fl.controls.DataGrid;
	import fl.data.DataProvider; 
	import flash.display.Shape;
	
	import fl.events.ListEvent;
	
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.controls.listClasses.CellRenderer;
	import fl.controls.ScrollPolicy;
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.controls.List;
	import fl.controls.ComboBox;
	
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
	import catfishqa.windows.htmlPage;
	import catfishqa.windows.MessageBox;
	import catfishqa.admin.roadmap.roadmapSprintNew.RoadmapSprintNew;
	import catfishqa.admin.roadmap.roadmapSprintRemove.RoadmapSprintRemove;
	import catfishqa.admin.roadmap.roadmapSprintEdit.RoadmapSprintEdit;
	import catfishqa.admin.roadmap.roadmapTaskNew.RoadmapTaskNew;
	import catfishqa.admin.roadmap.roadmapTaskEdit.RoadmapTaskEdit;
	import catfishqa.admin.roadmap.roadmapTaskRemove.RoadmapTaskRemove;
	import catfishqa.admin.roadmap.htmlTable.HtmlTable;
	import catfishqa.admin.buttons.ButtonCellEdit;
	import catfishqa.admin.buttons.ButtonCellDelete;
	import catfishqa.admin.buttons.ButtonCellOpenLink;
	
	public class Roadmap extends NativeWindowInitOptions 
	{
		private var _newWindow:NativeWindow;
		private var _timer:Timer = new Timer(2000, 1);
		private var _border:Shape;
		
		private var _roadmapSprintsArray:Array = [];
		private var _roadmapTasksArray:Array = [];
		private var _roadmapSprintsSelectID:int = 0;
		private var _roadmapSprintsSelectName:String = "";
		private var _roadmapSprintsSelectDate:String = "";
		private var _roadmapSprintsSelectProject:String = "";
		
		private var _projects:Array = [];
		private var _projectLinkSelect:String = "";
		private var _labelProject:Label;
		private var _comboBoxProject:ComboBox = new ComboBox();
		private var _buttonProject:Button;
		
		private var _label1:Label;
		private var _list:List;
		private var _button1:Button;
		private var _button2:Button;
		private var _button3:Button;
		
		private var _buttonAdd:Button = new Button();
		private var _dataGrid:DataGrid;
		
		private var _htmlTable:HtmlTable;
		
		public function Roadmap() 
		{
			super();
			
			transparent = false; 
			systemChrome = NativeWindowSystemChrome.STANDARD; 
			type = NativeWindowType.NORMAL; 
     
			_newWindow = new NativeWindow(this); 
			_newWindow.title = "Роадмап"; 
			_newWindow.width = 1000; 
			_newWindow.height = 600; 
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
			_list.setSize(225, _newWindow.height - 135);
			_dataGrid.setSize(_newWindow.width - 265, 200);
			CreateHtmlTable();
		}
		
		private function onServerEvents(event:ServerEvents):void 
		{
			switch(event.param.id)
			{
				case Server.ROADMAP_SPRINTS_UPDATE: 
				{
					UpdateList();
					break;
				}
				
				case Server.ROADMAP_SPRINTS_NOT_UPDATE: 
				{
					_timer.start();
					break;
				}
				
				case Server.ROADMAP_TASKS_UPDATE: 
				{
					UpdateDataGrid();
					break;
				}
				
				case Server.ROADMAP_TASKS_NOT_UPDATE: 
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
		
		/* Получить данные с сервера ======================================*/
		private function QueryTeamGroupsSelect():void
		{
			var _query:Query;
			var sqlCommand:String = "SELECT * FROM team_groups";
			
			_query = new Query();
			_query.performRequest(Server.serverPath + "team_groups_get.php?client=" + Server.client + "&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onQueryTeamGroupComplete);
		}
		
		private function onQueryTeamGroupComplete(event:Object):void 
		{
			_projects = [];
			
			var json_str:String = (event.target.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].team) 
				{
					_projects.push( { 
						label:json_data[i].team[k].team_groups_name,
						ID:json_data[i].team[k].team_groups_id,
						link:json_data[i].team[k].team_groups_link_project
					} );
					if (_roadmapSprintsSelectProject == "")
					{
						_projectLinkSelect = json_data[i].team[k].team_groups_link_project;
						_roadmapSprintsSelectProject = json_data[i].team[k].team_groups_name;
					}
				}
			}
			ToolbarProjects();
		}
		
		private function ToolbarProjects():void
		{
			_border = new Shape();
			_border.x = 0;
			_border.y = 0;
			_border.graphics.beginFill(0xDDDDDD,0.5);
			_border.graphics.drawRect(5, 2, 290, 30);
			_border.graphics.endFill();
			_newWindow.stage.addChild(_border);
			
			_labelProject = new Label();
			_labelProject.text = "Проект: "; 
			_labelProject.x = 15;
			_labelProject.y = 10;
			_labelProject.width = 250;
			_labelProject.height = 20;
			_newWindow.stage.addChild(_labelProject);
			
			_comboBoxProject.x = 60; 
			_comboBoxProject.y = 5;
			_comboBoxProject.name = "comboBoxProject";
			_comboBoxProject.dropdownWidth = 150; 
			_comboBoxProject.width = 150;  
			_comboBoxProject.selectedIndex = 0;
			_comboBoxProject.dataProvider = new DataProvider(_projects);
			_comboBoxProject.addEventListener(Event.CHANGE, onChangeComboBoxProject); 
			_newWindow.stage.addChild(_comboBoxProject);
			
			_buttonProject = new Button();
			_buttonProject.label = "Перейти";
			_buttonProject.x = 220; 
			_buttonProject.y = 5;
			_buttonProject.width = 70;
			_buttonProject.addEventListener(MouseEvent.CLICK, onButtonProjectClick);
			_newWindow.stage.addChild(_buttonProject);
			
			QuerySprintsSelect();
		}
		
		private function onChangeComboBoxProject(e:Event):void 
		{
			if ((e.target as ComboBox).name == "comboBoxProject") 
			{
				_projectLinkSelect = ComboBox(e.target).selectedItem.link;
				_roadmapSprintsSelectProject = ComboBox(e.target).selectedItem.label;
				UpdateList();
			}
		}
		
		private function onButtonProjectClick(e:MouseEvent):void 
		{
			var list:List = e.target as List;
			new htmlPage(_projectLinkSelect);
		}
		/* ================================================================*/
		
		/* =================================================================
		 * 
		 *  ЛИСТ
		 * 
		 * ================================================================*/
		
		/* Получить данные с сервера ======================================*/
		private function QuerySprintsSelect():void
		{
			var _query:Query;
			var sqlCommand:String = "SELECT * FROM roadmap_sprints WHERE (roadmap_sprints_project = '" + _roadmapSprintsSelectProject + "')";
			
			_query = new Query();
			_query.performRequest(Server.serverPath + "roadmap_sprints_get.php?client=" + Server.client + "&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onQuerySprintsComplete);
		}
		
		private function onQuerySprintsComplete(event:Event):void 
		{
			_roadmapSprintsArray = [];
			
			var json_str:String = (event.target.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].roadmap) 
				{
					_roadmapSprintsArray.push( { 
						label:json_data[i].roadmap[k].roadmap_sprints_name,
						ID:json_data[i].roadmap[k].roadmap_sprints_id,
						date:json_data[i].roadmap[k].roadmap_sprints_date,
						project:json_data[i].roadmap[k].roadmap_sprints_project
					} );
					
				}
			}
			ToolbarList();
		}
		/* ================================================================*/
		
		/* ПАНЕЛЬ ЛИСТА  ==================================================*/
		private function ToolbarList():void
		{
			var bSprintIcon:Bitmap = new Resource.ImageDatabaseIcon();
			bSprintIcon.x = 10;
			bSprintIcon.y = 40;
			_newWindow.stage.addChild(bSprintIcon);
			
			_label1 = new Label();
			_label1.text = "Спринт: "; 
			_label1.x = 30;
			_label1.y = 40;
			_label1.width = 250;
			_label1.height = 20;
			_label1.setStyle("textFormat", new TextFormat("Arial", 12, 0xffffff));
			_newWindow.stage.addChild(_label1);
			
			_button1 = new Button();
			_button1.label = "Добавить";
			_button1.x = 10; 
			_button1.y = 60;
			_button1.width = 70;
			_button1.addEventListener(MouseEvent.CLICK, onButton1Click);
			_newWindow.stage.addChild(_button1);
			
			_button2 = new Button();
			_button2.label = "Изменить";
			_button2.x = 85; 
			_button2.y = 60;
			_button2.width = 70;
			_button2.addEventListener(MouseEvent.CLICK, onButton2Click);
			_newWindow.stage.addChild(_button2);
			
			_button3 = new Button();
			_button3.label = "Удалить";
			_button3.x = 160; 
			_button3.y = 60;
			_button3.width = 70;
			_button3.addEventListener(MouseEvent.CLICK, onButton3Click);
			_newWindow.stage.addChild(_button3);
			
			CreateList();
		}
		
		private function CreateList():void
		{
			_list = new List();
			_list.addEventListener(ListEvent.ITEM_CLICK, onListClick);
			_list.setSize(225, _newWindow.height - 135); 
			_list.move(10, 90);
			_list.rowHeight = 20;
			_list.selectable = false;
			_list.verticalScrollPolicy = ScrollPolicy.ON;
			_list.dataProvider = new DataProvider(_roadmapSprintsArray);
			_newWindow.stage.addChild(_list);
			
			
			if (_list.dataProvider.length > 0)
			{
				_roadmapSprintsSelectID = _list.dataProvider.getItemAt(_list.dataProvider.length - 1).ID;
				_roadmapSprintsSelectName = _list.dataProvider.getItemAt(_list.dataProvider.length - 1).label;
				_roadmapSprintsSelectDate = _list.dataProvider.getItemAt(_list.dataProvider.length - 1).date;
				_roadmapSprintsSelectProject = _list.dataProvider.getItemAt(_list.dataProvider.length - 1).project;
			}else {
				_roadmapSprintsSelectID = 0;
				_roadmapSprintsSelectName = "";
				_roadmapSprintsSelectDate = "";
				//_roadmapSprintsSelectProject = "";
			}
			_label1.text = "Спринт: " + _roadmapSprintsSelectName;
			
			QueryTasksSelect();
		}
		
		private function UpdateList():void
		{
			_timer.stop();
			var _query:Query;
			var sqlCommand:String = "SELECT * FROM roadmap_sprints WHERE (roadmap_sprints_project = '" + _roadmapSprintsSelectProject + "')";
			_query = new Query();
			_query.performRequest(Server.serverPath + "roadmap_sprints_get.php?client=" + Server.client + "&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onUpdateListComplete);
		}
		
		private function onUpdateListComplete(event:Event):void 
		{
			_roadmapSprintsArray = [];
			var json_str:String = (event.target.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].roadmap) 
				{
					_roadmapSprintsArray.push( { 
						label:json_data[i].roadmap[k].roadmap_sprints_name,
						ID:json_data[i].roadmap[k].roadmap_sprints_id,
						date:json_data[i].roadmap[k].roadmap_sprints_date,
						project:json_data[i].roadmap[k].roadmap_sprints_project
					} );
					
				}
			}
			_list.dataProvider = new DataProvider(_roadmapSprintsArray);
			
			if (checkSelectSprint() == false)
			{
				_roadmapSprintsSelectID = 0;
				_roadmapSprintsSelectName = "";
				_roadmapSprintsSelectDate = "";
				//_roadmapSprintsSelectProject = "";
			}
			_label1.text = "Спринт: " + _roadmapSprintsSelectName;
			_timer.start();
			
			UpdateDataGrid();
		}
		
		private function checkSelectSprint():Boolean
		{
			var n:int = _list.dataProvider.length;
			for ( var i:int = 0; i < n; i++)
			{
				if (_roadmapSprintsSelectName == _list.dataProvider.getItemAt(i).label)
				{
					return true;
				}
			}
			return false;
		}
		
		private function onButton1Click(e:MouseEvent):void 
		{
			if (Resource.myStatus == Resource.ADMIN) new RoadmapSprintNew(_roadmapSprintsSelectProject);
		}
		
		private function onButton2Click(e:MouseEvent):void 
		{
			if (Resource.myStatus == Resource.ADMIN && _roadmapSprintsSelectName != "")
			{
				var data:Array = [];
				data.push({
					ID:_roadmapSprintsSelectID, 
					name:_roadmapSprintsSelectName,
					date:_roadmapSprintsSelectDate,
					project:_roadmapSprintsSelectProject
				});
				new RoadmapSprintEdit(data);
			}
		}
		
		private function onButton3Click(e:MouseEvent):void 
		{
			if (Resource.myStatus == Resource.ADMIN && _roadmapSprintsSelectName != "") new RoadmapSprintRemove(_roadmapSprintsSelectID.toString(), _roadmapSprintsSelectName);
		}
		
		private function onListClick(e:ListEvent):void 
		{
			var list:List = e.target as List;
			_roadmapSprintsSelectID = list.dataProvider.getItemAt(e.index).ID;
			_roadmapSprintsSelectName = list.dataProvider.getItemAt(e.index).label;
			_roadmapSprintsSelectDate = list.dataProvider.getItemAt(e.index).date;
			_roadmapSprintsSelectProject = list.dataProvider.getItemAt(e.index).project;
			
			_label1.text = "Спринт: " + _roadmapSprintsSelectName;
			UpdateDataGrid();
		}
		/* ================================================================*/
		
		/* ================================================================
		 * 
		 *  ТАБЛИЦА
		 * 
		 * ================================================================*/
		
		
		/* Получить данные с сервера ======================================*/
		private function QueryTasksSelect():void
		{
			var _query:Query;
			var sqlCommand:String = "SELECT * FROM roadmap_tasks WHERE roadmap_tasks_sprint_id = " + _roadmapSprintsSelectID + " ORDER BY roadmap_tasks_dev_begin ASC";
			_query = new Query();
			_query.performRequest(Server.serverPath + "roadmap_tasks_get.php?client=" + Server.client + "&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onQueryTasksComplete);
		}
		
		private function onQueryTasksComplete(event:Object):void 
		{
			_roadmapTasksArray = [];
			
			var json_str:String = (event.target.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].roadmap) 
				{
					_roadmapTasksArray.push( { 
						N:i+1,
						ID:json_data[i].roadmap[k].roadmap_tasks_id,
						Релиз:json_data[i].roadmap[k].roadmap_tasks_release,
						Версия:json_data[i].roadmap[k].roadmap_tasks_version,
						Задача:json_data[i].roadmap[k].roadmap_tasks_name,
						Ссылка:json_data[i].roadmap[k].roadmap_tasks_link,
						Изменить: (ButtonCellEdit),
						Удалить: (ButtonCellDelete),
						Открыть: (ButtonCellOpenLink),
						DEV_Begin:json_data[i].roadmap[k].roadmap_tasks_dev_begin,
						DEV_End:json_data[i].roadmap[k].roadmap_tasks_dev_end,
						QA_Begin:json_data[i].roadmap[k].roadmap_tasks_qa_begin,
						QA_End:json_data[i].roadmap[k].roadmap_tasks_qa_end,
						Проект:json_data[i].roadmap[k].roadmap_tasks_sprint_id 
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
			var buserIcon:Bitmap = new Resource.ImageCalendarIcon();
			buserIcon.x = 245;
			buserIcon.y = 60;
			_newWindow.stage.addChild(buserIcon);
			
			_buttonAdd.label = "Добавить задачу";
			_buttonAdd.x = 270; 
			_buttonAdd.y = 60;
			_buttonAdd.width = 150;
			_buttonAdd.addEventListener(MouseEvent.CLICK, onButtonAddMouseClick);
			_newWindow.stage.addChild(_buttonAdd);
		}
		
		private function onButtonAddMouseClick(e:MouseEvent):void 
		{
			if (Resource.myStatus == Resource.ADMIN && _roadmapSprintsSelectName != "")
			{
				new RoadmapTaskNew(_roadmapSprintsSelectProject, _roadmapSprintsSelectID.toString());
			}else {
				new MessageBox("Вы не выбрали спринт!", "Сообщение");
			}
		}
		/* ================================================================*/
		
		/* ТАБЛИЦА ========================================================*/
		private function CreateDataGrid():void
		{
			_dataGrid = new DataGrid();
			
			_dataGrid.addEventListener(ListEvent.ITEM_CLICK, onDataGridClick);
			
			_dataGrid.columns = [ "...", "N", "Релиз", "Версия", "Задача", "Изменить", "Удалить", "Открыть", "..."];
			
			var indexCellButton:Number = _dataGrid.getColumnIndex("Изменить");
            _dataGrid.getColumnAt(indexCellButton).cellRenderer = ButtonCellEdit;
			indexCellButton = _dataGrid.getColumnIndex("Удалить");
            _dataGrid.getColumnAt(indexCellButton).cellRenderer = ButtonCellDelete;
           	indexCellButton = _dataGrid.getColumnIndex("Открыть");
            _dataGrid.getColumnAt(indexCellButton).cellRenderer = ButtonCellOpenLink;
			
			_dataGrid.dataProvider = new DataProvider(_roadmapTasksArray); 
			
			_dataGrid.setSize(_newWindow.width - 265, 200);
			_dataGrid.move(240, 90);
			_dataGrid.rowHeight = 20;
			
			_dataGrid.columns[0].width = 25;
			_dataGrid.columns[1].width = 25;
			_dataGrid.columns[2].width = 150;
			_dataGrid.columns[3].width = 50;
			_dataGrid.columns[4].width = 200;
			_dataGrid.columns[5].width = 80;
			_dataGrid.columns[6].width = 80;
			_dataGrid.columns[7].width = 80;
			
			_dataGrid.resizableColumns = true; 
			_dataGrid.selectable = false;
			_dataGrid.editable = false;
			
			
			_dataGrid.verticalScrollPolicy = ScrollPolicy.AUTO; // полоса прокрутки
			_dataGrid.horizontalScrollPolicy = ScrollPolicy.AUTO; // полоса прокрутки
			
			_newWindow.stage.addChild(_dataGrid);
			
			TimerStart();
			CreateHtmlTable();
		}
		
		private function UpdateDataGrid():void
		{
			_timer.stop();
			var _query:Query;
			var sqlCommand:String = "SELECT * FROM roadmap_tasks WHERE roadmap_tasks_sprint_id = " + _roadmapSprintsSelectID + " ORDER BY roadmap_tasks_dev_begin ASC";
			_query = new Query();
			_query.performRequest(Server.serverPath + "roadmap_tasks_get.php?client=" + Server.client + "&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onUpdateDataGridComplete);
		}
		
		private function onUpdateDataGridComplete(event:Event):void 
		{
			_roadmapTasksArray = [];
			
			var json_str:String = (event.target.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].roadmap) 
				{
					_roadmapTasksArray.push( { 
						N:i+1,
						ID:json_data[i].roadmap[k].roadmap_tasks_id,
						Релиз:json_data[i].roadmap[k].roadmap_tasks_release,
						Версия:json_data[i].roadmap[k].roadmap_tasks_version,
						Задача:json_data[i].roadmap[k].roadmap_tasks_name,
						Ссылка:json_data[i].roadmap[k].roadmap_tasks_link,
						Изменить: (ButtonCellEdit),
						Удалить: (ButtonCellDelete),
						Открыть: (ButtonCellOpenLink),
						DEV_Begin:json_data[i].roadmap[k].roadmap_tasks_dev_begin,
						DEV_End:json_data[i].roadmap[k].roadmap_tasks_dev_end,
						QA_Begin:json_data[i].roadmap[k].roadmap_tasks_qa_begin,
						QA_End:json_data[i].roadmap[k].roadmap_tasks_qa_end,
						Проект:json_data[i].roadmap[k].roadmap_tasks_sprint_id 
					} );
					
				}
			}
			
			_dataGrid.dataProvider = new DataProvider(_roadmapTasksArray);
			_timer.start();
			CreateHtmlTable();
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
						Релиз:dg.dataProvider.getItemAt(e.index).Релиз, 
						Версия:dg.dataProvider.getItemAt(e.index).Версия,
						Задача:dg.dataProvider.getItemAt(e.index).Задача,
						Ссылка:dg.dataProvider.getItemAt(e.index).Ссылка,
						DEV_Begin:dg.dataProvider.getItemAt(e.index).DEV_Begin,
						DEV_End:dg.dataProvider.getItemAt(e.index).DEV_End,
						QA_Begin:dg.dataProvider.getItemAt(e.index).QA_Begin,
						QA_End:dg.dataProvider.getItemAt(e.index).QA_End,
						Проект:dg.dataProvider.getItemAt(e.index).Проект
					});
					new RoadmapTaskEdit(_roadmapSprintsSelectProject, _roadmapSprintsSelectID.toString(), data);
				}
				if (dg.columns[e.columnIndex].headerText == "Удалить")
				{
					new RoadmapTaskRemove(dg.dataProvider.getItemAt(e.index).ID, dg.dataProvider.getItemAt(e.index).Задача);
				}
				if (dg.columns[e.columnIndex].headerText == "Открыть")
				{
					new htmlPage(dg.dataProvider.getItemAt(e.index).Ссылка);
				}
			}
		}
		/* ================================================================*/
		
		/* ТАБЛИЦА (HTML) =================================================*/
		private function CreateHtmlTable():void
		{
			if (_newWindow.stage.getChildByName("htmlTable") != null) _newWindow.stage.removeChild(_newWindow.stage.getChildByName("htmlTable"));
			_htmlTable = new HtmlTable();
			_htmlTable.x = 240;
			_htmlTable.y = 300;
			_newWindow.stage.addChild(_htmlTable);
			_htmlTable.setSize(_newWindow.width - 270.0, _newWindow.height -340.0);
			if(_roadmapTasksArray.length > 0) _htmlTable.setData(_roadmapTasksArray);
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
			Server.checkTableUpdate(Server.ROADMAP_SPRINTS);
			Server.checkTableUpdate(Server.ROADMAP_TASKS);
		} 
		/* ================================================================*/
		
		
	}

}