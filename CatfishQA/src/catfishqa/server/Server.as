package catfishqa.server 
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import catfishqa.json.JSON;
	import catfishqa.mysql.Query; 
		 
	public class Server
	{
		private static var _query:Query;
				
		/* ПУТЬ К СЕРВЕРУ */
		public static var serverPath:String = "http://localhost/cf/catfishqa/"; //"http://catfishstudio.besaba.com/catfishqa/";
		
		/* КОНСТАНТЫ */
		public static const SYSTEM_USERS:String = "system_users"; // имя таблицы (Системные пользователи)
		public static const SYSTEM_USERS_UPDATE:String = "system_users_update"; // событие обновления таблицы (Системные пользователи)
		public static const SYSTEM_USERS_NOT_UPDATE:String = "system_users_not_update"; // событие обновления таблицы (Системные пользователи)
		
		
		/* ПОСЛЕНИЕ ОБНОВЛЕНИЯ */
		public static var last_update_system_users:String;
		
		
		
		/* МАССИВЫ ТАБЛИЦ */
		public static var systemUsersArray:Array = []; // Таблица базы данных system_users
		
		
		
		private static var dispatcher:EventDispatcher = new EventDispatcher();
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
            dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }
        public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
            dispatcher.removeEventListener(type, listener, useCapture);
        }
        public static function dispatchEvent(event:Event):Boolean {
            return dispatcher.dispatchEvent(event);
        }
        public static function hasEventListener(type:String):Boolean {
            return dispatcher.hasEventListener(type);
        }
		
		
		
		/* Проверка обновления талицы ============================================================*/
		public static function checkTableUpdate(tableName:String):void
		{
			if (tableName == SYSTEM_USERS)
			{
				_query = new Query();
				_query.performRequest(serverPath + "history_update_get.php?client=1&tableName=" + SYSTEM_USERS);
				_query.addEventListener("complete", onQuerySystemUsersComplete);
			}
		}
		
		private static function onQuerySystemUsersComplete(event:Object):void 
		{
			var json_str:String = (_query.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			
			if (json_data[0].table[0].history_update_name == SYSTEM_USERS)
			{
				if (json_data[0].table[0].history_update_datetime != last_update_system_users) //нужно обновиться
				{
					last_update_system_users = json_data[0].table[0].history_update_datetime;
					dispatchEvent(new ServerEvents(ServerEvents.TABLE_UPDATE, { id: SYSTEM_USERS_UPDATE }, true)); 
				}
				else
				{
					dispatchEvent(new ServerEvents(ServerEvents.TABLE_UPDATE, { id: SYSTEM_USERS_NOT_UPDATE }, true)); 
				}
			}
		}
		/*=========================================================================================*/
	}

}