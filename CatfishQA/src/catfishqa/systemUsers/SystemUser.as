package catfishqa.systemUsers 
{
	import fl.controls.DataGrid;
	import fl.controls.ScrollBar;
	import fl.data.DataProvider; 
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.controls.listClasses.CellRenderer;
	
	import fl.controls.ScrollPolicy;
	import flash.geom.Rectangle;
	
	import catfishqa.buttons.ButtonCellEdit;
	
	import flash.display.NativeWindow; 
	import flash.display.NativeWindowDisplayState;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import flash.net.URLRequest;
	
	import catfishqa.mysql.Query;
	import catfishqa.resource.Resource;
	import catfishqa.json.JSON;
	import catfishqa.events.Navigation;
	
	/**
	 * ...
	 * @author Catfish Studio Games
	 */
	
	public class SystemUser extends NativeWindowInitOptions 
	{
		private var _newWindow:NativeWindow;
		private var _dataGrid:DataGrid;
		
		private var _query:Query;
		
		
		public function SystemUser() 
		{
			super();
			
			transparent = false; 
			systemChrome = NativeWindowSystemChrome.STANDARD; 
			type = NativeWindowType.NORMAL; 
     
			_newWindow = new NativeWindow(this); 
			_newWindow.title = "A title"; 
			_newWindow.width = 600; 
			_newWindow.height = 400; 
			_newWindow.alwaysInFront = true; // всегда поверх других окон
			
			_newWindow.stage.align = StageAlign.TOP_LEFT; 
			_newWindow.stage.scaleMode = StageScaleMode.NO_SCALE; 
			_newWindow.activate(); 
			
			QueryInDataBase();
		}
		
		
		private function QueryInDataBase():void
		{
			_query = new Query();
			_query.performRequest(Resource.server + "system_users_get.php?client=1");
			_query.addEventListener("complete", onQueryComplete);
		}
		
		private function onQueryComplete(event:Object):void 
		{
			Resource.systemUsersArray = [];
			
			var json_str:String = (_query.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			for (var i:Object in json_data) 
			{
				for (var k:Object in json_data[i].user) 
				{
					Resource.systemUsersArray.push( { ID:json_data[i].user[k].system_users_id, 
					Имя:json_data[i].user[k].system_users_name, 
					Логин:json_data[i].user[k].system_users_login,
					Пароль:json_data[i].user[k].system_users_pass,
					Администратор:json_data[i].user[k].system_users_admin
					} );
				}
			}

			CreateDataGrid();
		}
		
		
		
		private function CreateDataGrid():void
		{
			_dataGrid = new DataGrid();
			
			_dataGrid.dataProvider = new DataProvider(Resource.systemUsersArray); 
			
			_dataGrid.columns = [ "ID", "Имя", "Логин", "Пароль", "Администратор"];
			_dataGrid.setSize(550, 300);
			_dataGrid.move(10, 40);
			_dataGrid.rowHeight = 20;
			
			_dataGrid.columns[0].width = 25;
			_dataGrid.columns[1].width = 150;
			_dataGrid.columns[2].width = 150;
			_dataGrid.columns[3].width = 50;
			_dataGrid.columns[4].width = 50;
			
			
			_dataGrid.resizableColumns = true; 
			_dataGrid.selectable = false;
			_dataGrid.editable = false;
			
			
			_dataGrid.verticalScrollPolicy = ScrollPolicy.AUTO; // полоса прокрутки
			_dataGrid.horizontalScrollPolicy = ScrollPolicy.AUTO; // полоса прокрутки
			//_dataGrid.rowCount = _dataGrid.length;
			
			var btnCol:DataGridColumn = new DataGridColumn("Редактировать запись");
			btnCol.cellRenderer = ButtonCellEdit;
			btnCol.editable = false;
			_dataGrid.addColumn(btnCol);
			
			_newWindow.stage.addChild(_dataGrid);
		}
		
	}

}