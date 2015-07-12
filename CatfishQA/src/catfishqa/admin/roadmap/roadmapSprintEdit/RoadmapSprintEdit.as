package catfishqa.admin.roadmap.roadmapSprintEdit 
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
	
	public class RoadmapSprintEdit extends NativeWindowInitOptions 
	{
		private var _newWindow:NativeWindow;
		
		private var _label1:Label;
		private var _textBox1:TextInput;
		
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
		private var _label2:Label;
		private var _comboBox2:ComboBox = new ComboBox();
		private var _comboBox3:ComboBox = new ComboBox();
		private var _textBox2:TextInput;
		
		private var _project:String;
		private var _projects:Array = [];
		private var _labelProject:Label;
		private var _comboBoxProject:ComboBox = new ComboBox();
		
		private var _button1:Button;
		private var _button2:Button;
		
		private var _query:Query;
		
		private var _data:Array = [];
		
		public function RoadmapSprintEdit(data:Array) 
		{
			super();
			_data = data;
			
			transparent = false; 
			systemChrome = NativeWindowSystemChrome.STANDARD; 
			type = NativeWindowType.NORMAL; 
     
			_newWindow = new NativeWindow(this); 
			_newWindow.title = "Редактировать спринт"; 
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
				}
			}
			Show();
		}
		/*=================================================================*/
		
		private function Show():void
		{
			_label1 = new Label();
			_label1.text = "Имя спринта:"; 
			_label1.x = 10;
			_label1.y = 10;
			_label1.width = 125;
			_newWindow.stage.addChild(_label1);
			
			_textBox1 = new TextInput();
			_textBox1.text = _data[0].name;
			_textBox1.x = 125; 
			_textBox1.y = 10;
			_textBox1.width = 200;
			_newWindow.stage.addChild(_textBox1);
			
			_label2 = new Label();
			_label2.text = "Дата:"; 
			_label2.x = 10;
			_label2.y = 40;
			_label2.width = 125;
			_newWindow.stage.addChild(_label2);
			
			_comboBox2.x = 120; 
			_comboBox2.y = 40;
			_comboBox2.name = "comboBox2";
			_comboBox2.dropdownWidth = 50; 
			_comboBox2.width = 50;  
			_comboBox2.selectedIndex = 0;
			_comboBox2.dataProvider = new DataProvider(_days);
			_newWindow.stage.addChild(_comboBox2);
			
			_comboBox3.x = 175; 
			_comboBox3.y = 40;
			_comboBox3.name = "comboBox3";
			_comboBox3.dropdownWidth = 95; 
			_comboBox3.width = 95;  
			_comboBox3.selectedIndex = 0;
			_comboBox3.dataProvider = new DataProvider(_mounts);
			_newWindow.stage.addChild(_comboBox3);
			
			_textBox2 = new TextInput();
			_textBox2.text = "2015";
			_textBox2.x = 275; 
			_textBox2.y = 40;
			_textBox2.width = 50;
			_newWindow.stage.addChild(_textBox2);
			
			_labelProject = new Label();
			_labelProject.text = "Проект: "; 
			_labelProject.x = 10;
			_labelProject.y = 70;
			_labelProject.width = 250;
			_labelProject.height = 20;
			_newWindow.stage.addChild(_labelProject);
			
			_comboBoxProject.x = 120; 
			_comboBoxProject.y = 70;
			_comboBoxProject.name = "comboBoxProject";
			_comboBoxProject.dropdownWidth = 150; 
			_comboBoxProject.width = 150;  
			_comboBoxProject.selectedIndex = 0;
			_comboBoxProject.dataProvider = new DataProvider(_projects);
			_newWindow.stage.addChild(_comboBoxProject);
			
			_project = _data[0].project;
			SelectProject();
			SelectDate();
			
			_button1 = new Button();
			_button1.label = "Сохранить";
			_button1.x = 100; _button1.y = 125;
			_button1.addEventListener(MouseEvent.CLICK, onButton1MouseClick);
			_newWindow.stage.addChild(_button1);
			
			_button2 = new Button();
			_button2.label = "Отмена";
			_button2.x = 225; _button2.y = 125;
			_button2.addEventListener(MouseEvent.CLICK, onButton2MouseClick);
			_newWindow.stage.addChild(_button2);
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
		
		private function SelectDate():void
		{
			var date:String = _data[0].date;
			var year:String = date.charAt(0) + date.charAt(1) + date.charAt(2) + date.charAt(3);
			var mount:String = date.charAt(5) + date.charAt(6);
			var day:String = date.charAt(8) + date.charAt(9);
			
			_textBox2.text = year;
			
			var n:int = _mounts.length;
			for (var m:int = 0; m < n; m++)
			{
				if (_mounts[m].data == mount)
				{
					_comboBox3.selectedIndex = m;
					break;
				}
			}
			
			n = _days.length;
			for (var d:int = 0; d < n; d++)
			{
				if (_days[d].data == day)
				{
					_comboBox2.selectedIndex = d;
					break;
				}
			}
		}
		
		
		private function onButton1MouseClick(e:MouseEvent):void 
		{
			var sqlCommand:String = "UPDATE roadmap_sprints SET "
								+ "roadmap_sprints_name = '" + _textBox1.text + "', "
								+ "roadmap_sprints_date = '" + _textBox2.text + "-" + _comboBox3.selectedItem.data + "-" + _comboBox2.selectedItem.data + "', "
								+ "roadmap_sprints_project = '" + _comboBoxProject.text + "' "
								+ "WHERE roadmap_sprints_id = " + _data[0].ID;
			
			_query = new Query();
			_query.performRequest(Server.serverPath + "roadmap_sprints_set.php?client=1&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onQuery1Complete);
		}
		
		private function onQuery1Complete(e:Event):void 
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