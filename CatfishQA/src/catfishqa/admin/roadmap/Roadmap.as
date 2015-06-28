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
	import catfishqa.admin.roadmap.roadmapSprintNew.RoadmapSprintNew;
	import catfishqa.admin.roadmap.roadmapSprintRemove.RoadmapSprintRemove;
	import catfishqa.admin.roadmap.roadmapSprintEdit.RoadmapSprintEdit;
	
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
		
		public function Roadmap() 
		{
			super();
			
			transparent = false; 
			systemChrome = NativeWindowSystemChrome.STANDARD; 
			type = NativeWindowType.NORMAL; 
     
			_newWindow = new NativeWindow(this); 
			_newWindow.title = "Роадмап"; 
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
			//_list.setSize(225, _newWindow.height - 110);
			//_dataGrid.setSize(_newWindow.width - 265, _newWindow.height - 110);
		}
		
		private function onServerEvents(event:ServerEvents):void 
		{
			switch(event.param.id)
			{
				case Server.ROADMAP_SPRINTS_UPDATE: 
				{
					//UpdateList();
					break;
				}
				
				case Server.ROADMAP_SPRINTS_NOT_UPDATE: 
				{
					_timer.start();
					break;
				}
				
				case Server.ROADMAP_TASKS_UPDATE: 
				{
					//UpdateDataGrid();
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
			_query.performRequest(Server.serverPath + "team_groups_get.php?client=1&sqlcommand=" + sqlCommand);
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
			_query.performRequest(Server.serverPath + "roadmap_sprints_get.php?client=1&sqlcommand=" + sqlCommand);
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
			var bSprintIcon:Bitmap = new Resource.ImageUserDatabaseIcon();
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
			//_list.addEventListener(ListEvent.ITEM_CLICK, onListClick);
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
				_roadmapSprintsSelectProject = "";
			}
			_label1.text = "Спринт: " + _roadmapSprintsSelectName;
			
			//QueryTeamUsersSelect();
		}
		
		private function UpdateList():void
		{
			_timer.stop();
			var _query:Query;
			var sqlCommand:String = "SELECT * FROM roadmap_sprints WHERE (roadmap_sprints_project = '" + _roadmapSprintsSelectProject + "')";
			_query = new Query();
			_query.performRequest(Server.serverPath + "roadmap_sprints_get.php?client=1&sqlcommand=" + sqlCommand);
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
				_roadmapSprintsSelectProject = "";
			}
			_label1.text = "Спринт: " + _roadmapSprintsSelectName;
			_timer.start();
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
		
		
	}

}