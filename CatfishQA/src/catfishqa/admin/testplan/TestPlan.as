package catfishqa.admin.testplan 
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
	import fl.controls.ComboBox;
	
	import flash.display.Shape;
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
	
	import catfishqa.admin.testplan.testplanSprintNew.TestplanSprintNew;
	
	import catfishqa.admin.buttons.ButtonCellEdit;
	import catfishqa.admin.buttons.ButtonCellDelete;
	import catfishqa.admin.buttons.ButtonCellOpenLink;
	import catfishqa.admin.htmltextfield.HtmlTextField;
	
	
	public class TestPlan extends NativeWindowInitOptions 
	{
		private var _newWindow:NativeWindow;
		private var _timer:Timer = new Timer(2000, 1);
		private var _border:Shape;
		
		private var _testplanSprintsArray:Array = [];
		private var _testplanTasksArray:Array = [];
		private var _testplanSprintsSelectID:int = 0;
		private var _testplanSprintsSelectName:String = "";
		private var _testplanSprintsSelectDate:String = "";
		private var _testplanSprintsSelectProject:String = "";
		
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
		
		public function TestPlan() 
		{
			super();
			
			transparent = false; 
			systemChrome = NativeWindowSystemChrome.STANDARD; 
			type = NativeWindowType.NORMAL; 
     
			_newWindow = new NativeWindow(this); 
			_newWindow.title = "Тест план"; 
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
			_dataGrid.setSize(_newWindow.width - 265, _newWindow.height - 140);
		}
		
		private function onServerEvents(event:ServerEvents):void 
		{
			switch(event.param.id)
			{
				case Server.TESTPLAN_SPRINTS_UPDATE: 
				{
					UpdateList();
					break;
				}
				
				case Server.TESTPLAN_SPRINTS_NOT_UPDATE: 
				{
					_timer.start();
					break;
				}
				
				case Server.TESTPLAN_TASKS_UPDATE: 
				{
					UpdateDataGrid();
					break;
				}
				
				case Server.TESTPLAN_TASKS_NOT_UPDATE: 
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
					if (_testplanSprintsSelectProject == "")
					{
						_projectLinkSelect = json_data[i].team[k].team_groups_link_project;
						_testplanSprintsSelectProject = json_data[i].team[k].team_groups_name;
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
				_testplanSprintsSelectProject = ComboBox(e.target).selectedItem.label;
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
			var sqlCommand:String = "SELECT * FROM test_plan_sprints WHERE (test_plan_sprints_project = '" + _testplanSprintsSelectProject + "')";
			
			_query = new Query();
			_query.performRequest(Server.serverPath + "test_plan_sprints_get.php?client=" + Server.client + "&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onQuerySprintsComplete);
		}
		
		private function onQuerySprintsComplete(event:Event):void 
		{
			_testplanSprintsArray = [];
			
			var json_str:String = (event.target.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].testplane) 
				{
					_testplanSprintsArray.push( { 
						label:json_data[i].testplane[k].test_plan_sprints_name,
						ID:json_data[i].testplane[k].test_plan_sprints_id,
						date:json_data[i].testplane[k].test_plan_sprints_date,
						project:json_data[i].testplane[k].test_plan_sprints_project
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
			_list.dataProvider = new DataProvider(_testplanSprintsArray);
			_newWindow.stage.addChild(_list);
			
			
			if (_list.dataProvider.length > 0)
			{
				_testplanSprintsSelectID = _list.dataProvider.getItemAt(_list.dataProvider.length - 1).ID;
				_testplanSprintsSelectName = _list.dataProvider.getItemAt(_list.dataProvider.length - 1).label;
				_testplanSprintsSelectDate = _list.dataProvider.getItemAt(_list.dataProvider.length - 1).date;
				_testplanSprintsSelectProject = _list.dataProvider.getItemAt(_list.dataProvider.length - 1).project;
			}else {
				_testplanSprintsSelectID = 0;
				_testplanSprintsSelectName = "";
				_testplanSprintsSelectDate = "";
				//_roadmapSprintsSelectProject = "";
			}
			_label1.text = "Спринт: " + _testplanSprintsSelectName;
			
			QueryTasksSelect();
		}
		
		private function UpdateList():void
		{
			_timer.stop();
			var _query:Query;
			var sqlCommand:String = "SELECT * FROM test_plan_sprints WHERE (test_plan_sprints_project = '" + _testplanSprintsSelectProject + "')";
			_query = new Query();
			_query.performRequest(Server.serverPath + "test_plan_sprints_get.php?client=" + Server.client + "&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onUpdateListComplete);
		}
		
		private function onUpdateListComplete(event:Event):void 
		{
			_testplanSprintsArray = [];
			var json_str:String = (event.target.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].testplane) 
				{
					_testplanSprintsArray.push( { 
						label:json_data[i].testplane[k].test_plan_sprints_name,
						ID:json_data[i].testplane[k].test_plan_sprints_id,
						date:json_data[i].testplane[k].test_plan_sprints_date,
						project:json_data[i].testplane[k].test_plan_sprints_project
					} );
					
				}
			}
			_list.dataProvider = new DataProvider(_testplanSprintsArray);
			
			if (checkSelectSprint() == false)
			{
				_testplanSprintsSelectID = 0;
				_testplanSprintsSelectName = "";
				_testplanSprintsSelectDate = "";
				//_roadmapSprintsSelectProject = "";
			}
			_label1.text = "Спринт: " + _testplanSprintsSelectName;
			_timer.start();
			
			UpdateDataGrid();
		}
		
		private function checkSelectSprint():Boolean
		{
			var n:int = _list.dataProvider.length;
			for ( var i:int = 0; i < n; i++)
			{
				if (_testplanSprintsSelectName == _list.dataProvider.getItemAt(i).label)
				{
					return true;
				}
			}
			return false;
		}
		
		private function onButton1Click(e:MouseEvent):void 
		{
			if (Resource.myStatus == Resource.ADMIN) new TestplanSprintNew(_testplanSprintsSelectProject);
		}
		
		private function onButton2Click(e:MouseEvent):void 
		{
			/*
			if (Resource.myStatus == Resource.ADMIN && _roadmapSprintsSelectName != "")
			{
				var data:Array = [];
				data.push({
					ID:_testplanSprintsSelectID, 
					name:_testplanSprintsSelectName,
					date:_testplanSprintsSelectDate,
					project:_testplanSprintsSelectProject
				});
				new RoadmapSprintEdit(data);
			}
			*/
		}
		
		private function onButton3Click(e:MouseEvent):void 
		{
			//if (Resource.myStatus == Resource.ADMIN && _testplanSprintsSelectName != "") new RoadmapSprintRemove(_testplanSprintsSelectID.toString(), _testplanSprintsSelectName);
		}
		
		private function onListClick(e:ListEvent):void 
		{
			var list:List = e.target as List;
			_testplanSprintsSelectID = list.dataProvider.getItemAt(e.index).ID;
			_testplanSprintsSelectName = list.dataProvider.getItemAt(e.index).label;
			_testplanSprintsSelectDate = list.dataProvider.getItemAt(e.index).date;
			_testplanSprintsSelectProject = list.dataProvider.getItemAt(e.index).project;
			
			_label1.text = "Спринт: " + _testplanSprintsSelectName;
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
			var sqlCommand:String = "SELECT * FROM test_plan_tasks WHERE test_plan_tasks_sprint_name = '" + _testplanSprintsSelectName + "' ORDER BY test_plan_tasks_testing_begin ASC";
			
			_query = new Query();
			_query.performRequest(Server.serverPath + "test_plan_tasks_get.php?client=" + Server.client + "&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onQueryTasksComplete);
		}
		
		private function onQueryTasksComplete(event:Object):void 
		{
			_testplanTasksArray = [];
			
			var json_str:String = (event.target.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].testplan) 
				{
					_testplanTasksArray.push( { 
						N:i+1,
						ID:json_data[i].testplan[k].test_plan_tasks_id,
						Дата:json_data[i].testplan[k].test_plan_tasks_testing_begin,
						Задача:json_data[i].testplan[k].test_plan_tasks_name,
						СсылкаЗадача:json_data[i].testplan[k].test_plan_tasks_link,
						Тесткейс:json_data[i].testplan[k].test_plan_tasks_create_test_case_qa,
						QA:json_data[i].testplan[k].test_plan_tasks_testing_qa,
						СсылкаТесткейс:json_data[i].testplan[k].test_plan_tasks_link_test_case,
						Статус:json_data[i].testplan[k].test_plan_tasks_status,
						Android:json_data[i].testplan[k].test_plan_tasks_result_android,
						iOS:json_data[i].testplan[k].test_plan_tasks_result_ios,
						Web:json_data[i].testplan[k].test_plan_tasks_result_web,
						Изменить: (ButtonCellEdit),
						Удалить: (ButtonCellDelete),
						Открыть: (ButtonCellOpenLink),
						Спринт:json_data[i].testplan[k].test_plan_tasks_sprint_name
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
			if (Resource.myStatus == Resource.ADMIN && _testplanSprintsSelectName != "")
			{
				//new RoadmapTaskNew(_testplanSprintsSelectProject, _testplanSprintsSelectID.toString());
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
			
			_dataGrid.columns = [ "...", "N", "Дата", "Задача", "Тесткейс", "QA", "Статус", "Android", "iOS", "Web", "Изменить", "Удалить", "Открыть", "..."];
			
			var indexCellButton:Number = _dataGrid.getColumnIndex("Изменить");
            _dataGrid.getColumnAt(indexCellButton).cellRenderer = ButtonCellEdit;
			indexCellButton = _dataGrid.getColumnIndex("Удалить");
            _dataGrid.getColumnAt(indexCellButton).cellRenderer = ButtonCellDelete;
           	indexCellButton = _dataGrid.getColumnIndex("Открыть");
            _dataGrid.getColumnAt(indexCellButton).cellRenderer = ButtonCellOpenLink;
			
			// !!!!!!!!!!!!!!!!!! _dataGrid.getColumnAt(6).cellRenderer = HtmlTextField; // статус
			
			_dataGrid.dataProvider = new DataProvider(_testplanTasksArray); 
			
			_dataGrid.setSize(_newWindow.width - 265, _newWindow.height - 140);
			_dataGrid.move(240, 90);
			_dataGrid.rowHeight = 20;
			
			_dataGrid.columns[0].width = 25;
			_dataGrid.columns[1].width = 25;
			_dataGrid.columns[2].width = 100;
			_dataGrid.columns[3].width = 200;
			_dataGrid.columns[4].width = 100;
			_dataGrid.columns[5].width = 100;
			_dataGrid.columns[6].width = 75;
			_dataGrid.columns[7].width = 50;
			_dataGrid.columns[8].width = 50;
			_dataGrid.columns[9].width = 50;
			
			_dataGrid.resizableColumns = true; 
			_dataGrid.selectable = false;
			_dataGrid.editable = false;
			
			
			_dataGrid.verticalScrollPolicy = ScrollPolicy.ON; // полоса прокрутки
			_dataGrid.horizontalScrollPolicy = ScrollPolicy.ON; // полоса прокрутки
			
			_newWindow.stage.addChild(_dataGrid);
			
			TimerStart();
		}
		
		private function UpdateDataGrid():void
		{
			_timer.stop();
			var _query:Query;
			var sqlCommand:String = "SELECT * FROM test_plan_tasks WHERE test_plan_tasks_sprint_name = '" + _testplanSprintsSelectName + "' ORDER BY test_plan_tasks_testing_begin ASC";
			_query = new Query();
			_query.performRequest(Server.serverPath + "test_plan_tasks_get.php?client=" + Server.client + "&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onUpdateDataGridComplete);
		}
		
		private function onUpdateDataGridComplete(event:Event):void 
		{
			_testplanTasksArray = [];
			
			var json_str:String = (event.target.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].testplan) 
				{
					_testplanTasksArray.push( { 
						N:i+1,
						ID:json_data[i].testplan[k].test_plan_tasks_id,
						Дата:json_data[i].testplan[k].test_plan_tasks_testing_begin,
						Задача:json_data[i].testplan[k].test_plan_tasks_name,
						СсылкаЗадача:json_data[i].testplan[k].test_plan_tasks_link,
						Тесткейс:json_data[i].testplan[k].test_plan_tasks_create_test_case_qa,
						QA:json_data[i].testplan[k].test_plan_tasks_testing_qa,
						СсылкаТесткейс:json_data[i].testplan[k].test_plan_tasks_link_test_case,
						Статус:json_data[i].testplan[k].test_plan_tasks_status,
						Android:json_data[i].testplan[k].test_plan_tasks_result_android,
						iOS:json_data[i].testplan[k].test_plan_tasks_result_ios,
						Web:json_data[i].testplan[k].test_plan_tasks_result_web,
						Изменить: (ButtonCellEdit),
						Удалить: (ButtonCellDelete),
						Открыть: (ButtonCellOpenLink),
						Спринт:json_data[i].testplan[k].test_plan_tasks_sprint_name
					} );
					
				}
			}
			
			_dataGrid.dataProvider = new DataProvider(_testplanTasksArray);
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
					data.push( {
						
						ID:dg.dataProvider.getItemAt(e.index).ID,
						Дата:dg.dataProvider.getItemAt(e.index).Дата,
						Задача:dg.dataProvider.getItemAt(e.index).Задача,
						СсылкаЗадача:dg.dataProvider.getItemAt(e.index).СсылкаЗадача,
						Тесткейс:dg.dataProvider.getItemAt(e.index).Тесткейс,
						QA:dg.dataProvider.getItemAt(e.index).QA,
						СсылкаТесткейс:dg.dataProvider.getItemAt(e.index).СсылкаТесткейс,
						Статус:dg.dataProvider.getItemAt(e.index).Статус,
						Android:dg.dataProvider.getItemAt(e.index).Android,
						iOS:dg.dataProvider.getItemAt(e.index).iOS,
						Web:dg.dataProvider.getItemAt(e.index).Web,
						Проект:dg.dataProvider.getItemAt(e.index).Проект 
					});
					//new RoadmapTaskEdit(_testplanSprintsSelectProject, _testplanSprintsSelectID.toString(), data);
				}
				if (dg.columns[e.columnIndex].headerText == "Удалить")
				{
					//new RoadmapTaskRemove(dg.dataProvider.getItemAt(e.index).ID, dg.dataProvider.getItemAt(e.index).Задача);
				}
				if (dg.columns[e.columnIndex].headerText == "Открыть")
				{
					new htmlPage(dg.dataProvider.getItemAt(e.index).СсылкаЗадача);
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
			Server.checkTableUpdate(Server.TESTPLAN_SPRINTS);
			Server.checkTableUpdate(Server.TESTPLAN_TASKS);
		} 
		/* ================================================================*/
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}

}