package catfishqa.admin.roadmap.roadmapTaskNew 
{
	import flash.display.NativeWindow; 
	import flash.display.NativeWindowDisplayState;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Shape;
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
	
	public class RoadmapTaskNew extends NativeWindowInitOptions 
	{
		private var _newWindow:NativeWindow;
		private var _border:Shape;
		private var _sprintSelectID:String;
		private var _projectSelect:String;
		private var _sprintsArray:Array = [];
		private var _query:Query;
		
		private var _label1:Label = new Label();
		private var _comboBox1:ComboBox = new ComboBox();
		
		private var _label2:Label;
		private var _comboBox2:ComboBox = new ComboBox();
		private var _comboBox3:ComboBox = new ComboBox();
		private var _textBox2:TextInput;
		
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
		
		private var _label3:Label;
		private var _comboBox4:ComboBox = new ComboBox();
		
		private var _version:Array = new Array( 
			{label:"Мобильная", data:"Mob"},
			{label:"Социальная", data:"Soc"} 
		);
		
		private var _label4:Label;
		private var _textBox3:TextInput;
		
		private var _label5:Label;
		private var _textBox4:TextInput;
		
		private var _label6:Label;
		private var _label7:Label;
		private var _comboBox5:ComboBox = new ComboBox();
		private var _comboBox6:ComboBox = new ComboBox();
		private var _textBox5:TextInput;
		private var _label8:Label;
		private var _comboBox7:ComboBox = new ComboBox();
		private var _comboBox8:ComboBox = new ComboBox();
		private var _textBox6:TextInput;
		
		private var _label9:Label;
		private var _label10:Label;
		private var _comboBox9:ComboBox = new ComboBox();
		private var _comboBox10:ComboBox = new ComboBox();
		private var _textBox7:TextInput;
		private var _label11:Label;
		private var _comboBox11:ComboBox = new ComboBox();
		private var _comboBox12:ComboBox = new ComboBox();
		private var _textBox8:TextInput;
		
		private var _button1:Button;
		private var _button2:Button;
		
		public function RoadmapTaskNew(projectSelect:String, sprintSelectID:String) 
		{
			super();
			_sprintSelectID = sprintSelectID;
			_projectSelect = projectSelect;
			
			transparent = false; 
			systemChrome = NativeWindowSystemChrome.STANDARD; 
			type = NativeWindowType.NORMAL; 
     
			_newWindow = new NativeWindow(this); 
			_newWindow.title = "Новыя задача"; 
			_newWindow.width = 350; 
			_newWindow.height = 400; 
			_newWindow.stage.color = 0xDDDDDD;
			_newWindow.alwaysInFront = true; // всегда поверх других окон
			
			_newWindow.stage.align = StageAlign.TOP_LEFT; 
			_newWindow.stage.scaleMode = StageScaleMode.NO_SCALE; 
			_newWindow.activate();
			
			QuerySprintsSelect();
		}
		
		/* Получить данные с сервера ======================================*/
		private function QuerySprintsSelect():void
		{
			var _query:Query;
			var sqlCommand:String = "SELECT * FROM roadmap_sprints WHERE (roadmap_sprints_project = '" + _projectSelect + "')";
			
			_query = new Query();
			_query.performRequest(Server.serverPath + "roadmap_sprints_get.php?client=1&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onQuerySprintsComplete);
		}
		
		private function onQuerySprintsComplete(event:Event):void 
		{
			_sprintsArray = [];
			
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
		/* ================================================================*/
		
		private function Show():void
		{
			_label1.text = "Спринт:"; 
			_label1.x = 10;
			_label1.y = 15;
			_label1.width = 50;
			_newWindow.stage.addChild(_label1);
			
			_comboBox1.x = 70; 
			_comboBox1.y = 10;
			_comboBox1.name = "comboBox1";
			_comboBox1.dropdownWidth = 255; 
			_comboBox1.width = 255;  
			_comboBox1.selectedIndex = 0;
			_comboBox1.dataProvider = new DataProvider(_sprintsArray);
			_newWindow.stage.addChild(_comboBox1);
			
			SelectSprint();
			
			_label2 = new Label();
			_label2.text = "Релиз:"; 
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
			
			_label3 = new Label();
			_label3.text = "Версия: "; 
			_label3.x = 10;
			_label3.y = 70;
			_label3.width = 250;
			_label3.height = 20;
			_newWindow.stage.addChild(_label3);
			
			_comboBox4.x = 120; 
			_comboBox4.y = 70;
			_comboBox4.name = "comboBox4";
			_comboBox4.dropdownWidth = 205; 
			_comboBox4.width = 205;  
			_comboBox4.selectedIndex = 0;
			_comboBox4.dataProvider = new DataProvider(_version);
			_newWindow.stage.addChild(_comboBox4);
			
			_label4 = new Label();
			_label4.text = "Задача: "; 
			_label4.x = 10;
			_label4.y = 100;
			_label4.width = 250;
			_label4.height = 20;
			_newWindow.stage.addChild(_label4);
			
			_textBox3 = new TextInput();
			_textBox3.text = "";
			_textBox3.x = 120; 
			_textBox3.y = 100;
			_textBox3.width = 205;
			_newWindow.stage.addChild(_textBox3);
			
			_label5 = new Label();
			_label5.text = "Ссылка: "; 
			_label5.x = 10;
			_label5.y = 130;
			_label5.width = 250;
			_label5.height = 20;
			_newWindow.stage.addChild(_label5);
			
			_textBox4 = new TextInput();
			_textBox4.text = "http://";
			_textBox4.x = 120; 
			_textBox4.y = 130;
			_textBox4.width = 205;
			_newWindow.stage.addChild(_textBox4);
			
			//--------------------------------
			_border = new Shape();
			_border.x = 10;
			_border.y = 175;
			_border.graphics.beginFill(0xFFFFFF,0.5);
			_border.graphics.drawRect(0, 0, 315, 60);
			_border.graphics.endFill();
			_newWindow.stage.addChild(_border);
			
			_label6 = new Label();
			_label6.text = "DEV: "; 
			_label6.x = 10;
			_label6.y = 160;
			_label6.width = 250;
			_label6.height = 20;
			_newWindow.stage.addChild(_label6);
			
			_label7 = new Label();
			_label7.text = "Начало работы:"; 
			_label7.x = 15;
			_label7.y = 180;
			_label7.width = 125;
			_newWindow.stage.addChild(_label7);
			
			_comboBox5.x = 115; 
			_comboBox5.y = 180;
			_comboBox5.name = "comboBox5";
			_comboBox5.dropdownWidth = 50; 
			_comboBox5.width = 50;  
			_comboBox5.selectedIndex = 0;
			_comboBox5.dataProvider = new DataProvider(_days);
			_newWindow.stage.addChild(_comboBox5);
			
			_comboBox6.x = 170; 
			_comboBox6.y = 180;
			_comboBox6.name = "comboBox6";
			_comboBox6.dropdownWidth = 95; 
			_comboBox6.width = 95;  
			_comboBox6.selectedIndex = 0;
			_comboBox6.dataProvider = new DataProvider(_mounts);
			_newWindow.stage.addChild(_comboBox6);
			
			_textBox5 = new TextInput();
			_textBox5.text = "2015";
			_textBox5.x = 270; 
			_textBox5.y = 180;
			_textBox5.width = 50;
			_newWindow.stage.addChild(_textBox5);
			
			_label8 = new Label();
			_label8.text = "Конец работы:"; 
			_label8.x = 15;
			_label8.y = 210;
			_label8.width = 125;
			_newWindow.stage.addChild(_label8);
			
			_comboBox7.x = 115; 
			_comboBox7.y = 210;
			_comboBox7.name = "comboBox7";
			_comboBox7.dropdownWidth = 50; 
			_comboBox7.width = 50;  
			_comboBox7.selectedIndex = 0;
			_comboBox7.dataProvider = new DataProvider(_days);
			_newWindow.stage.addChild(_comboBox7);
			
			_comboBox8.x = 170; 
			_comboBox8.y = 210;
			_comboBox8.name = "comboBox8";
			_comboBox8.dropdownWidth = 95; 
			_comboBox8.width = 95;  
			_comboBox8.selectedIndex = 0;
			_comboBox8.dataProvider = new DataProvider(_mounts);
			_newWindow.stage.addChild(_comboBox8);
			
			_textBox6 = new TextInput();
			_textBox6.text = "2015";
			_textBox6.x = 270; 
			_textBox6.y = 210;
			_textBox6.width = 50;
			_newWindow.stage.addChild(_textBox6);
			
			//-------------------------
			_border = new Shape();
			_border.x = 10;
			_border.y = 250;
			_border.graphics.beginFill(0xFFFFFF,0.5);
			_border.graphics.drawRect(0, 0, 315, 60);
			_border.graphics.endFill();
			_newWindow.stage.addChild(_border);
			
			_label9 = new Label();
			_label9.text = "QA: "; 
			_label9.x = 10;
			_label9.y = 235;
			_label9.width = 250;
			_label9.height = 20;
			_newWindow.stage.addChild(_label9);
			
			_label10 = new Label();
			_label10.text = "Начало работы:"; 
			_label10.x = 15;
			_label10.y = 255;
			_label10.width = 125;
			_newWindow.stage.addChild(_label10);
			
			_comboBox9.x = 115; 
			_comboBox9.y = 255;
			_comboBox9.name = "comboBox9";
			_comboBox9.dropdownWidth = 50; 
			_comboBox9.width = 50;  
			_comboBox9.selectedIndex = 0;
			_comboBox9.dataProvider = new DataProvider(_days);
			_newWindow.stage.addChild(_comboBox9);
			
			_comboBox10.x = 170; 
			_comboBox10.y = 255;
			_comboBox10.name = "comboBox10";
			_comboBox10.dropdownWidth = 95; 
			_comboBox10.width = 95;  
			_comboBox10.selectedIndex = 0;
			_comboBox10.dataProvider = new DataProvider(_mounts);
			_newWindow.stage.addChild(_comboBox10);
			
			_textBox7 = new TextInput();
			_textBox7.text = "2015";
			_textBox7.x = 270; 
			_textBox7.y = 255;
			_textBox7.width = 50;
			_newWindow.stage.addChild(_textBox7);
			
			_label11 = new Label();
			_label11.text = "Конец работы:"; 
			_label11.x = 15;
			_label11.y = 285;
			_label11.width = 125;
			_newWindow.stage.addChild(_label11);
			
			_comboBox11.x = 115; 
			_comboBox11.y = 285;
			_comboBox11.name = "comboBox11";
			_comboBox11.dropdownWidth = 50; 
			_comboBox11.width = 50;  
			_comboBox11.selectedIndex = 0;
			_comboBox11.dataProvider = new DataProvider(_days);
			_newWindow.stage.addChild(_comboBox11);
			
			_comboBox12.x = 170; 
			_comboBox12.y = 285;
			_comboBox12.name = "comboBox12";
			_comboBox12.dropdownWidth = 95; 
			_comboBox12.width = 95;  
			_comboBox12.selectedIndex = 0;
			_comboBox12.dataProvider = new DataProvider(_mounts);
			_newWindow.stage.addChild(_comboBox12);
			
			_textBox8 = new TextInput();
			_textBox8.text = "2015";
			_textBox8.x = 270; 
			_textBox8.y = 285;
			_textBox8.width = 50;
			_newWindow.stage.addChild(_textBox8);
			
			//---------------------------
			_button1 = new Button();
			_button1.label = "Сохранить";
			_button1.x = 100; _button1.y = 325;
			_button1.addEventListener(MouseEvent.CLICK, onButton1MouseClick);
			_newWindow.stage.addChild(_button1);
			
			_button2 = new Button();
			_button2.label = "Отмена";
			_button2.x = 225; _button2.y = 325;
			_button2.addEventListener(MouseEvent.CLICK, onButton2MouseClick);
			_newWindow.stage.addChild(_button2);
		}
		
		private function SelectSprint():void
		{
			var n:int = _sprintsArray.length;
			for (var i:int = 0; i < n; i++)
			{
				if (_sprintsArray[i].ID == _sprintSelectID)
				{
					_comboBox1.selectedIndex = i;
					break;
				}
			}
		}
		
		private function onButton1MouseClick(e:MouseEvent):void 
		{
			var sqlCommand:String = "INSERT INTO roadmap_tasks "
								+ "(roadmap_tasks_release, roadmap_tasks_version, roadmap_tasks_name, roadmap_tasks_link, roadmap_tasks_dev_begin, roadmap_tasks_dev_end, roadmap_tasks_qa_begin, roadmap_tasks_qa_end, roadmap_tasks_sprint_id) VALUES ("
								+ "'" + _textBox2.text + "-" + _comboBox3.selectedItem.data + "-" + _comboBox2.selectedItem.data + "', "
								+ "'" + _comboBox4.selectedItem.data + "', "
								+ "'" + _textBox3.text + "', "
								+ "'" + _textBox4.text + "', "
								+ "'" + _textBox5.text + "-" + _comboBox6.selectedItem.data + "-" + _comboBox5.selectedItem.data + "', "
								+ "'" + _textBox6.text + "-" + _comboBox8.selectedItem.data + "-" + _comboBox7.selectedItem.data + "', "
								+ "'" + _textBox7.text + "-" + _comboBox10.selectedItem.data + "-" + _comboBox9.selectedItem.data + "', "
								+ "'" + _textBox8.text + "-" + _comboBox12.selectedItem.data + "-" + _comboBox11.selectedItem.data + "', "
								+ "'" + _comboBox1.selectedItem.ID + "')"
								
			
			_query = new Query();
			_query.performRequest(Server.serverPath + "roadmap_tasks_set.php?client=1&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onQueryComplete);
		}
		
		private function onQueryComplete(e:Event):void 
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