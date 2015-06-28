package catfishqa.admin.roadmap 
{
	import fl.controls.DataGrid;
	import fl.controls.TextInput;
	import fl.data.DataProvider; 
	import flash.display.Shape;
	
	import fl.events.ListEvent;
	
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.controls.listClasses.CellRenderer;
	import fl.controls.ScrollPolicy;
	import fl.controls.Button;
	import fl.controls.Label;
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
	
	import flash.utils.Timer;
	import flash.events.TimerEvent; 
	
	import catfishqa.mysql.Query;
	import catfishqa.server.Server;
	import catfishqa.server.ServerEvents;
	import catfishqa.resource.Resource;
	import catfishqa.json.JSON;
	
	import catfishqa.client.buttons.ButtonCellEdit;
	import catfishqa.client.buttons.ButtonCellDelete;
	
	public class _Roadmap extends NativeWindowInitOptions 
	{
		private var _newWindow:NativeWindow;
		
		private var _border:Shape;
		
		private var _projects:Array = [];
		private var _label1:Label;
		private var _comboBox1:ComboBox = new ComboBox();
		
		private var _label2:Label;
		private var _comboBox2:ComboBox = new ComboBox();
		private var _comboBox3:ComboBox = new ComboBox();
		private var _textBox1:TextInput = new TextInput();
		private var _label3:Label;
		private var _comboBox4:ComboBox = new ComboBox();
		private var _comboBox5:ComboBox = new ComboBox();
		private var _textBox2:TextInput = new TextInput();
		
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
			{label:"12", data:"12" } 
		);
		
		private var _button1:Button = new Button();
		
		private var _buttonAdd:Button = new Button();
		private var _dataGrid:DataGrid;
		
		
		
		private var _timer:Timer = new Timer(2000, 1);
		
		public var roadmapArray:Array = []; // Таблица базы данных
		
		
		public function _Roadmap() 
		{
			super();
			transparent = false; 
			systemChrome = NativeWindowSystemChrome.STANDARD; 
			type = NativeWindowType.NORMAL; 
     
			_newWindow = new NativeWindow(this); 
			_newWindow.title = "Роадмап"; 
			_newWindow.width = 800; 
			_newWindow.height = 400; 
			_newWindow.stage.color = 0xA8ABC6; //0xDDDDDD;
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
			//_dataGrid.setSize(_newWindow.width - 50, _newWindow.height - 110);
		}
		
		private function onServerEvents(event:ServerEvents):void 
		{
			switch(event.param.id)
			{
				case Server.ROADMAP_PROJECTS_UPDATE: 
				{
					//UpdateDataGrid();
					break;
				}
				
				case Server.ROADMAP_PROJECTS_NOT_UPDATE: 
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
						Link:json_data[i].team[k].team_groups_link_project
					} );
					
				}
			}
			Toolbar();
			ButtonAdd();
		}
		/* ================================================================*/
		
		/* Панель инструментов ==========================================================*/
		private function Toolbar():void
		{
			_border = new Shape();
			_border.x = 0;
			_border.y = 0;
			_border.graphics.beginFill(0xDDDDDD,0.5);
			_border.graphics.drawRect(5, 2, 740, 30);
			_border.graphics.endFill();
			_newWindow.stage.addChild(_border);
			
			_label1 = new Label();
			_label1.text = "Проект: "; 
			_label1.x = 15;
			_label1.y = 10;
			_label1.width = 250;
			_label1.height = 20;
			//_label1.setStyle("textFormat", new TextFormat("Arial", 12, 0xffffff));
			_newWindow.stage.addChild(_label1);
			
			_comboBox1.x = 60; 
			_comboBox1.y = 5;
			_comboBox1.name = "comboBox1";
			_comboBox1.dropdownWidth = 150; 
			_comboBox1.width = 150;  
			_comboBox1.selectedIndex = 0;
			_comboBox1.dataProvider = new DataProvider(_projects);
			_comboBox1.addEventListener(Event.CHANGE, onChangeComboBox); 
			_newWindow.stage.addChild(_comboBox1);
			
			_label2 = new Label();
			_label2.text = "Период: с"; 
			_label2.x = 230;
			_label2.y = 10;
			_label2.width = 250;
			_label2.height = 20;
			//_label2.setStyle("textFormat", new TextFormat("Arial", 12, 0xffffff));
			_newWindow.stage.addChild(_label2);
			
			_comboBox2.x = 290; 
			_comboBox2.y = 5;
			_comboBox2.name = "comboBox2";
			_comboBox2.dropdownWidth = 50; 
			_comboBox2.width = 50;  
			_comboBox2.selectedIndex = 0;
			_comboBox2.dataProvider = new DataProvider(_days);
			_comboBox2.addEventListener(Event.CHANGE, onChangeComboBox); 
			_newWindow.stage.addChild(_comboBox2);
			
			_comboBox3.x = 345; 
			_comboBox3.y = 5;
			_comboBox3.name = "comboBox3";
			_comboBox3.dropdownWidth = 50; 
			_comboBox3.width = 50;  
			_comboBox3.selectedIndex = 0;
			_comboBox3.dataProvider = new DataProvider(_mounts);
			_comboBox3.addEventListener(Event.CHANGE, onChangeComboBox); 
			_newWindow.stage.addChild(_comboBox3);
			
			_textBox1.text = "2015";
			_textBox1.x = 400; 
			_textBox1.y = 5;
			_textBox1.width = 50;
			_newWindow.stage.addChild(_textBox1);
			
			_label3 = new Label();
			_label3.text = " по "; 
			_label3.x = 450;
			_label3.y = 10;
			_label3.width = 250;
			_label3.height = 20;
			//_label3.setStyle("textFormat", new TextFormat("Arial", 12, 0xffffff));
			_newWindow.stage.addChild(_label3);
			
			_comboBox4.x = 470; 
			_comboBox4.y = 5;
			_comboBox4.name = "comboBox4";
			_comboBox4.dropdownWidth = 50; 
			_comboBox4.width = 50;  
			_comboBox4.selectedIndex = 0;
			_comboBox4.dataProvider = new DataProvider(_days);
			_comboBox4.addEventListener(Event.CHANGE, onChangeComboBox); 
			_newWindow.stage.addChild(_comboBox4);
			
			_comboBox5.x = 525; 
			_comboBox5.y = 5;
			_comboBox5.name = "comboBox5";
			_comboBox5.dropdownWidth = 50; 
			_comboBox5.width = 50;  
			_comboBox5.selectedIndex = 0;
			_comboBox5.dataProvider = new DataProvider(_mounts);
			_comboBox5.addEventListener(Event.CHANGE, onChangeComboBox); 
			_newWindow.stage.addChild(_comboBox5);
			
			_textBox2.text = "2015";
			_textBox2.x = 580; 
			_textBox2.y = 5;
			_textBox2.width = 50;
			_newWindow.stage.addChild(_textBox2);
			
			_button1.label = "Применить";
			_button1.x = 640; 
			_button1.y = 5;
			_button1.width = 100;
			_button1.addEventListener(MouseEvent.CLICK, onButtonApplyClick);
			_newWindow.stage.addChild(_button1);
		}
		
		private function onButtonApplyClick(e:MouseEvent):void 
		{
			
		}
				
		private function onChangeComboBox(e:Event):void 
		{
			if ((e.target as ComboBox).name == "comboBox1") 
			{
				if (ComboBox(e.target).selectedItem.label == "...")
				{
					//_textBox2.text = "";
					//_textBox3.text = "";
				}else{
					//_textBox2.text = ComboBox(e.target).selectedItem.name;
					//_textBox3.text = ComboBox(e.target).selectedItem.login;
				}
			}
		}
		
		/* Кнопка =================================================================*/
		private function ButtonAdd():void
		{
			_buttonAdd.label = "Добавить задачу";
			_buttonAdd.x = 10; 
			_buttonAdd.y = 40;
			_buttonAdd.width = 120;
			_buttonAdd.addEventListener(MouseEvent.CLICK, onButtonAddMouseClick);
			_newWindow.stage.addChild(_buttonAdd);
		}
		
		private function onButtonAddMouseClick(e:MouseEvent):void 
		{
			if (Resource.myStatus == Resource.ADMIN)
			{
				//new TeamUserNew(_tempGroupsSelectName);
			}
		}
		/* ================================================================*/
		
	}

}