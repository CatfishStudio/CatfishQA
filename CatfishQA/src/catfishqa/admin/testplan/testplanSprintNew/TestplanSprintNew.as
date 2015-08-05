package catfishqa.admin.testplan.testplanSprintNew 
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
	
	public class TestplanSprintNew extends NativeWindowInitOptions 
	{
		private var _newWindow:NativeWindow;
		
		private var _days:Array = new Array( 
			{label:"01", data:"01" },
			{label:"02", data:"02" },
			{label:"03", data:"03" },
			{label:"04", data:"04" },
			{label:"05", data:"05" },
			{label:"06", data:"06" },
			{label:"07", data:"07" },
			{label:"08", data:"08" },
			{label:"09", data:"09" },
			{label:"10", data:"10" },
			{label:"11", data:"11" },
			{label:"12", data:"12" },
			{label:"13", data:"13" },
			{label:"14", data:"14" },
			{label:"15", data:"15" },
			{label:"16", data:"16" },
			{label:"17", data:"17" },
			{label:"18", data:"18" },
			{label:"19", data:"19" },
			{label:"20", data:"20" },
			{label:"21", data:"21" },
			{label:"22", data:"22" },
			{label:"23", data:"23" },
			{label:"24", data:"24" },
			{label:"25", data:"25" },
			{label:"26", data:"26" },
			{label:"27", data:"27" },
			{label:"28", data:"28" },
			{label:"29", data:"29" },
			{label:"30", data:"30" },
			{label:"31", data:"31" } 
		);
		
		private var _mounts:Array = new Array( 
			{label:"Январь", data:"01" },
			{label:"Февраль", data:"02" },
			{label:"Март", data:"03" },
			{label:"Апрель", data:"04" },
			{label:"Май", data:"05" },
			{label:"Июнь", data:"06" },
			{label:"Июль", data:"07" },
			{label:"Август", data:"08" },
			{label:"Сентябрь", data:"09" },
			{label:"Октябрь", data:"10" },
			{label:"Ноябырь", data:"11" },
			{label:"Декабрь", data:"12" } 
		);
		
		private var _label1:Label;
		private var _textBox1:TextInput;
		
		
		private var _label2:Label;
		private var _comboBox2:ComboBox = new ComboBox();
		private var _comboBox3:ComboBox = new ComboBox();
		private var _textBox2:TextInput;
		
		private var _project:String;
		private var _projects:Array = [];
		private var _labelProject:Label;
		private var _comboBoxProject:ComboBox = new ComboBox();
		
		private var _sprintsArray:Array = [];
		private var _sprintName:String;
		private var _sprintID:int = 0;
		private var _labelSprint:Label;
		private var _comboBoxSprint:ComboBox = new ComboBox();
		private var _tasksArray:Array = [];
		
		private var _button1:Button;
		private var _button2:Button;
		
		private var _query:Query;
		
		
		public function TestplanSprintNew(project:String) 
		{
			super();
			
			_project = project;
			
			transparent = false; 
			systemChrome = NativeWindowSystemChrome.STANDARD; 
			type = NativeWindowType.NORMAL; 
     
			_newWindow = new NativeWindow(this); 
			_newWindow.title = "Новый спринт"; 
			_newWindow.width = 350; 
			_newWindow.height = 200; 
			_newWindow.stage.color = 0xDDDDDD;
			_newWindow.alwaysInFront = true; // всегда поверх других окон
			
			_newWindow.stage.align = StageAlign.TOP_LEFT; 
			_newWindow.stage.scaleMode = StageScaleMode.NO_SCALE; 
			_newWindow.activate();
			
			QueryTeamGroupsSelect();
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
				}
			}
			QuerySprintsSelect();
		}
		
		private function QuerySprintsSelect():void
		{
			var _query:Query;
			var sqlCommand:String = "SELECT * FROM roadmap_sprints WHERE (roadmap_sprints_project = '" + _project + "')";
			
			_query = new Query();
			_query.performRequest(Server.serverPath + "roadmap_sprints_get.php?client=" + Server.client + "&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onQuerySprintsComplete);
		}
		
		private function onQuerySprintsComplete(event:Event):void 
		{
			_sprintsArray = [];
			_sprintsArray.push( { 
				label: "...",
				ID:"...",
				date:"...",
				project:"..."
			} );
			
			var json_str:String = (event.target.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].roadmap) 
				{
					_sprintsArray.push( { 
						label:json_data[i].roadmap[k].roadmap_sprints_name,
						ID:json_data[i].roadmap[k].roadmap_sprints_id,
						date:json_data[i].roadmap[k].roadmap_sprints_date,
						project:json_data[i].roadmap[k].roadmap_sprints_project
					} );
					
				}
			}
			
			Show();
		}
		
		private function QueryTasksSelect():void
		{
			var _query:Query;
			var sqlCommand:String = "SELECT * FROM roadmap_tasks WHERE roadmap_tasks_sprint_id = '" + _sprintID.toString() + "' ORDER BY roadmap_tasks_dev_begin ASC";
			_query = new Query();
			_query.performRequest(Server.serverPath + "roadmap_tasks_get.php?client=" + Server.client + "&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onQueryTasksComplete);
		}
		
		private function onQueryTasksComplete(event:Event):void 
		{
			_tasksArray = [];
			
			var json_str:String = (event.target.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].roadmap) 
				{
					_tasksArray.push( { 
						N:i+1,
						ID:json_data[i].roadmap[k].roadmap_tasks_id,
						Релиз:json_data[i].roadmap[k].roadmap_tasks_release,
						Версия:json_data[i].roadmap[k].roadmap_tasks_version,
						Задача:json_data[i].roadmap[k].roadmap_tasks_name,
						Ссылка:json_data[i].roadmap[k].roadmap_tasks_link,
						DEV_Begin:json_data[i].roadmap[k].roadmap_tasks_dev_begin,
						DEV_End:json_data[i].roadmap[k].roadmap_tasks_dev_end,
						QA_Begin:json_data[i].roadmap[k].roadmap_tasks_qa_begin,
						QA_End:json_data[i].roadmap[k].roadmap_tasks_qa_end,
						Проект:json_data[i].roadmap[k].roadmap_tasks_sprint_id 
					} );
				}
			}
		}
		/*=================================================================*/
		
		private function Show():void
		{
			_labelSprint = new Label();
			_labelSprint.text = "Спринт:"; 
			_labelSprint.x = 10;
			_labelSprint.y = 15;
			_labelSprint.width = 50;
			_newWindow.stage.addChild(_labelSprint);
			
			_comboBoxSprint = new ComboBox();
			_comboBoxSprint.x = 70; 
			_comboBoxSprint.y = 10;
			_comboBoxSprint.name = "comboBoxSprint";
			_comboBoxSprint.dropdownWidth = 255; 
			_comboBoxSprint.width = 255;  
			_comboBoxSprint.selectedIndex = 0;
			_comboBoxSprint.dataProvider = new DataProvider(_sprintsArray);
			_comboBoxSprint.addEventListener(Event.CHANGE, onChangeComboBox);
			_newWindow.stage.addChild(_comboBoxSprint);
			
			
			_label1 = new Label();
			_label1.text = "Имя спринта:"; 
			_label1.x = 10;
			_label1.y = 40;
			_label1.width = 125;
			_newWindow.stage.addChild(_label1);
			
			_textBox1 = new TextInput();
			_textBox1.text = "";
			_textBox1.x = 125; 
			_textBox1.y = 40;
			_textBox1.width = 200;
			_newWindow.stage.addChild(_textBox1);
			
			_label2 = new Label();
			_label2.text = "Дата:"; 
			_label2.x = 10;
			_label2.y = 70;
			_label2.width = 125;
			_newWindow.stage.addChild(_label2);
			
			_comboBox2.x = 120; 
			_comboBox2.y = 70;
			_comboBox2.name = "comboBox2";
			_comboBox2.dropdownWidth = 50; 
			_comboBox2.width = 50;  
			_comboBox2.selectedIndex = 0;
			_comboBox2.dataProvider = new DataProvider(_days);
			_newWindow.stage.addChild(_comboBox2);
			
			_comboBox3.x = 175; 
			_comboBox3.y = 70;
			_comboBox3.name = "comboBox3";
			_comboBox3.dropdownWidth = 95; 
			_comboBox3.width = 95;  
			_comboBox3.selectedIndex = 0;
			_comboBox3.dataProvider = new DataProvider(_mounts);
			_newWindow.stage.addChild(_comboBox3);
			
			_textBox2 = new TextInput();
			_textBox2.text = "2015";
			_textBox2.x = 275; 
			_textBox2.y = 70;
			_textBox2.width = 50;
			_newWindow.stage.addChild(_textBox2);
			
			
			_labelProject = new Label();
			_labelProject.text = "Проект: "; 
			_labelProject.x = 10;
			_labelProject.y = 100;
			_labelProject.width = 250;
			_labelProject.height = 20;
			_newWindow.stage.addChild(_labelProject);
			
			_comboBoxProject.x = 120; 
			_comboBoxProject.y = 100;
			_comboBoxProject.name = "comboBoxProject";
			_comboBoxProject.dropdownWidth = 150; 
			_comboBoxProject.width = 150;  
			_comboBoxProject.selectedIndex = 0;
			_comboBoxProject.dataProvider = new DataProvider(_projects);
			_newWindow.stage.addChild(_comboBoxProject);
			
			SelectProject();
			
			_button1 = new Button();
			_button1.label = "Сохранить";
			_button1.x = 100; _button1.y = 135;
			_button1.addEventListener(MouseEvent.CLICK, onButton1MouseClick);
			_newWindow.stage.addChild(_button1);
			
			_button2 = new Button();
			_button2.label = "Отмена";
			_button2.x = 225; _button2.y = 135;
			_button2.addEventListener(MouseEvent.CLICK, onButton2MouseClick);
			_newWindow.stage.addChild(_button2);
		}
		
		private function onChangeComboBox(e:Event):void 
		{
			if ((e.target as ComboBox).name == "comboBoxSprint") 
			{
				if (ComboBox(e.target).selectedItem.label == "...")
				{
					_tasksArray = [];
					_textBox1.text = "";
				}else {
					_sprintID = ComboBox(e.target).selectedItem.ID;
					_sprintName = ComboBox(e.target).selectedItem.label;
					QueryTasksSelect();
					_textBox1.text = ComboBox(e.target).selectedItem.label;
					
				}
			}
		}
		
		private function SelectProject():void
		{
			var n:int = _projects.length;
			for (var i:int = 0; i < n; i++)
			{
				if (_projects[i].label == _project)
				{
					_comboBoxProject.selectedIndex = i;
					break;
				}
			}
		}
		
		private function onButton1MouseClick(e:MouseEvent):void 
		{
			var sqlCommand:String = "INSERT INTO test_plan_sprints "
								+ "(test_plan_sprints_name, test_plan_sprints_date, test_plan_sprints_project) VALUES ("
								+ "'" + _textBox1.text + "', "
								+ "'" + _textBox2.text + "-" + _comboBox3.selectedItem.data + "-" + _comboBox2.selectedItem.data + "', "
								+ "'" + _comboBoxProject.text + "')"
								
			
			_query = new Query();
			_query.performRequest(Server.serverPath + "test_plan_sprints_set.php?client=" + Server.client + "&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onQuerySprintInsertComplete);
		}
		
		private function onQuerySprintInsertComplete(e:Event):void 
		{
			
			if ((_query.getResult as String) == "complete")
			{
				if (_tasksArray.length != 0) QueryTasksInsert();
				else _newWindow.close();
			}else {
				new MessageBox((_query.getResult as String), "Сообщение");
			}
		}
		
		private function QueryTasksInsert():void
		{
			if(_tasksArray != null)
			var sqlCommand:String = "INSERT INTO test_plan_tasks (test_plan_tasks_testing_begin, test_plan_tasks_name, test_plan_tasks_link, test_plan_tasks_create_test_case_qa, test_plan_tasks_testing_qa, test_plan_tasks_link_test_case, test_plan_tasks_status, test_plan_tasks_result_android, test_plan_tasks_result_ios, test_plan_tasks_result_web, test_plan_tasks_sprint_name) VALUES ";
			var n:int = _sprintsArray.length;
			for (var i:int = 0; i < n; i++)
			{
				if (i != (n - 1))
				{
					sqlCommand += "('" + _tasksArray[i].QA_Begin + "', '" + _tasksArray[i].Задача + "', '" + _tasksArray[i].Ссылка + "', '', '', -1, 'PROCESS', '', '', '', '" + _sprintName + "'), ";
				}else {
					sqlCommand += "('" + _tasksArray[i].QA_Begin + "', '" + _tasksArray[i].Задача + "', '" + _tasksArray[i].Ссылка + "', '', '', -1, 'PROCESS', '', '', '', '" + _sprintName + "')";
				}
			}
			trace(sqlCommand);
			_query = new Query();
			_query.performRequest(Server.serverPath + "test_plan_tasks_set.php?client=" + Server.client + "&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onQueryTasksInsertComplete);
		}
		
		private function onQueryTasksInsertComplete(e:Event):void 
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