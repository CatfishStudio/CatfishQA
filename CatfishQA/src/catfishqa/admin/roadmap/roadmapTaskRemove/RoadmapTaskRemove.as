package catfishqa.admin.roadmap.roadmapTaskRemove 
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
	
	public class RoadmapTaskRemove extends NativeWindowInitOptions 
	{
		private var _newWindow:NativeWindow;
		private var _query:Query;
		private var _label1:Label = new Label();
		private var _button1:Button = new Button();
		private var _button2:Button = new Button();
		
		private var _taskID:String;
		private var _taskName:String;
		
		public function RoadmapTaskRemove(taskID:String, taskName:String) 
		{
			super();
			_taskID = taskID;
			_taskName = taskName;
			
			transparent = false; 
			systemChrome = NativeWindowSystemChrome.STANDARD; 
			type = NativeWindowType.UTILITY; 
     
			_newWindow = new NativeWindow(this); 
			_newWindow.title = "Удалить задачу"; 
			_newWindow.width = 350; 
			_newWindow.height = 150; 
			_newWindow.stage.color = 0xDDDDDD;
			_newWindow.alwaysInFront = true; // всегда поверх других окон
			
			_newWindow.stage.align = StageAlign.TOP_LEFT; 
			_newWindow.stage.scaleMode = StageScaleMode.NO_SCALE; 
			_newWindow.activate();
			
			_label1.text = "Удалить задачу \"" + _taskName + "\" ?";
			_label1.wordWrap = true;
			_label1.x = 10;
			_label1.y = 20;
			_label1.width = 300;
			_label1.height = 100;
			_newWindow.stage.addChild(_label1);
			
			_button1.label = "Да";
			_button1.x = 50; _button1.y = 80;
			_button1.addEventListener(MouseEvent.CLICK, onButton1MouseClick);
			_newWindow.stage.addChild(_button1);
			
			_button2.label = "Нет";
			_button2.x = 175; _button2.y = 80;
			_button2.addEventListener(MouseEvent.CLICK, onButton2MouseClick);
			_newWindow.stage.addChild(_button2);
		}
		
		private function onButton1MouseClick(e:MouseEvent):void 
		{
			var sqlCommand:String = "DELETE FROM roadmap_tasks WHERE roadmap_tasks_id = " + _taskID;
			
			_query = new Query();
			_query.performRequest(Server.serverPath + "roadmap_tasks_set.php?client=1&sqlcommand=" + sqlCommand);
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