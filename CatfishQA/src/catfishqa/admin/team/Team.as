package catfishqa.admin.team 
{
	import fl.controls.DataGrid;
	import fl.data.DataProvider; 
	import flash.display.Bitmap;
	
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
	import catfishqa.admin.teamGroupsNew.TempGroupNew;
	import catfishqa.admin.teamGroupsEdit.TeamGroupEdit;
	import catfishqa.admin.teamGroupsRemove.TeamGroupRemove;
	
	public class Team extends NativeWindowInitOptions 
	{
		private var _newWindow:NativeWindow;
		private var _query:Query;
		private var _timer:Timer = new Timer(2000, 1);
		
		private var _tempGroupsArray:Array = [];
		private var _tempGroupsSelectID:int;
		private var _tempGroupsSelectName:String;
		private var _label1:Label;
		private var _list:List;
		private var _button1:Button;
		private var _button2:Button;
		private var _button3:Button;
		
		
		private var _dataGrid:DataGrid;
		
			
		
		
		private var _tempUsersArray:Array = [];
		
		
		public function Team() 
		{
			super();
			
			transparent = false; 
			systemChrome = NativeWindowSystemChrome.STANDARD; 
			type = NativeWindowType.NORMAL; 
     
			_newWindow = new NativeWindow(this); 
			_newWindow.title = "Команды"; 
			_newWindow.width = 700; 
			_newWindow.height = 450; 
			_newWindow.stage.color = 0xDDDDDD;
			_newWindow.alwaysInFront = true; // всегда поверх других окон
			
			_newWindow.stage.align = StageAlign.TOP_LEFT; 
			_newWindow.stage.scaleMode = StageScaleMode.NO_SCALE; 
			_newWindow.activate();
			
			_newWindow.addEventListener(Event.CLOSE, onClose);
			
			Server.addEventListener(ServerEvents.TABLE_UPDATE, onServerEvents);
			
			QueryTeamGroupsSelect();
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
				
				default:
				{
					break;
				}

			}
		}
		
		
		/* Получить данные с сервера ======================================*/
		private function QueryTeamGroupsSelect():void
		{
			var sqlCommand:String = "SELECT * FROM team_groups";
			
			_query = new Query();
			_query.performRequest(Server.serverPath + "team_groups_get.php?client=1&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onQueryComplete);
		}
		
		private function onQueryComplete(event:Object):void 
		{
			_tempGroupsArray = [];
			
			var json_str:String = (_query.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].team) 
				{
					_tempGroupsArray.push( { 
					//iconSource:,
					label:json_data[i].team[k].team_groups_name,
					ID:json_data[i].team[k].team_groups_id 
					} );
					
				}
			}
			groupShow();
		}
		/* ================================================================*/
		
		
		/* КОМАНДА ГРУППЫ ФОРМА ===========================================*/
		private function groupShow():void
		{
			var bGroupIcon:Bitmap = new Resource.ImageGroupIcon();
			bGroupIcon.x = 10;
			bGroupIcon.y = 5;
			_newWindow.stage.addChild(bGroupIcon);
			
			_label1 = new Label();
			_label1.text = "Группа: "; 
			_label1.x = 30;
			_label1.y = 5;
			_label1.width = 250;
			_label1.height = 20;
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
			_list.setSize(225, 350);
			_list.move(10, 60);
			_list.rowHeight = 20;
			_list.selectable = false;
			_list.verticalScrollPolicy = ScrollPolicy.AUTO;
			_list.dataProvider = new DataProvider(_tempGroupsArray);
			_newWindow.stage.addChild(_list);
			
			_tempGroupsSelectID = _list.dataProvider.getItemAt(_list.dataProvider.length - 1).ID;
			_tempGroupsSelectName = _list.dataProvider.getItemAt(_list.dataProvider.length - 1).label;
			_label1.text = "Группа: " + _tempGroupsSelectName;
			
			TimerStart();
		}
		
		private function UpdateList():void
		{
			var sqlCommand:String = "SELECT * FROM team_groups";
			_query = new Query();
			_query.performRequest(Server.serverPath + "team_groups_get.php?client=1&sqlcommand=" + sqlCommand);
			_query.addEventListener("complete", onUpdateListComplete);
		}
		
		private function onUpdateListComplete(e:Event):void 
		{
			_tempGroupsArray = [];
			var json_str:String = (_query.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].team) 
				{
					_tempGroupsArray.push( { 
					label:json_data[i].team[k].team_groups_name,
					ID:json_data[i].team[k].team_groups_id 
					} );
				}
			}
			_list.dataProvider = new DataProvider(_tempGroupsArray);
			_timer.start();
		}
		
		private function onButton1Click(e:MouseEvent):void 
		{
			if (Resource.myStatus == Resource.ADMIN) new TempGroupNew();
		}
		
		private function onButton2Click(e:MouseEvent):void 
		{
			if (Resource.myStatus == Resource.ADMIN)
			{
				var data:Array = [];
				data.push({
					ID:_tempGroupsSelectID, 
					Name:_tempGroupsSelectName 
				});
				new TeamGroupEdit(data);
			}
		}
		
		private function onButton3Click(e:MouseEvent):void 
		{
			if (Resource.myStatus == Resource.ADMIN) new TeamGroupRemove(_tempGroupsSelectID.toString(), _tempGroupsSelectName);
		}
		
		private function onListClick(e:ListEvent):void 
		{
			var list:List = e.target as List;
			_tempGroupsSelectID = list.dataProvider.getItemAt(e.index).ID;
			_tempGroupsSelectName = list.dataProvider.getItemAt(e.index).label;
			_label1.text = "Группа: " + _tempGroupsSelectName;
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
		} 
		/* ================================================================*/
	}

}