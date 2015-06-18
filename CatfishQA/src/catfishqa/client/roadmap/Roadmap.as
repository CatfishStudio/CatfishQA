package catfishqa.client.roadmap 
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
	import flash.events.NativeWindowBoundsEvent;
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
	
	import catfishqa.client.buttons.ButtonCellEdit;
	import catfishqa.client.buttons.ButtonCellDelete;
	
	public class Roadmap extends NativeWindowInitOptions 
	{
		private var _newWindow:NativeWindow;
		private var _dataGrid:DataGrid;
		private var _button:Button = new Button();
		
		private var _timer:Timer = new Timer(2000, 1);
		
		public var roadmapArray:Array = []; // Таблица базы данных
		
		
		public function Roadmap() 
		{
			super();
			transparent = false; 
			systemChrome = NativeWindowSystemChrome.STANDARD; 
			type = NativeWindowType.NORMAL; 
     
			_newWindow = new NativeWindow(this); 
			_newWindow.title = "Роадмап"; 
			_newWindow.width = 700; 
			_newWindow.height = 400; 
			_newWindow.stage.color = 0xA8ABC6; //0xDDDDDD;
			_newWindow.alwaysInFront = true; // всегда поверх других окон
			
			_newWindow.stage.align = StageAlign.TOP_LEFT; 
			_newWindow.stage.scaleMode = StageScaleMode.NO_SCALE; 
			_newWindow.activate();
			
			_newWindow.addEventListener(Event.CLOSE, onClose);
			_newWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, onResize);
			
			Server.addEventListener(ServerEvents.TABLE_UPDATE, onServerEvents);
			
			//ButtonAdd(); // Создать кнопку "добавить пользователя"
			
			//QuerySelect(); // Запрос к базе данных с дальнейшим созданием таблицы DataGrid
		}
		
		private function onClose(e:Event):void 
		{
			_timer.stop();
			_timer = null;
			Server.removeEventListener(ServerEvents.TABLE_UPDATE, onServerEvents);
		}
		
		private function onResize(e:NativeWindowBoundsEvent):void 
		{
			_dataGrid.setSize(_newWindow.width - 50, _newWindow.height - 110);
		}
		
		private function onServerEvents(event:ServerEvents):void 
		{
			switch(event.param.id)
			{
				case Server.ROADMAP_PROJECTS_UPDATE: 
				{
					UpdateDataGrid();
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
		
		
		
		
	}

}