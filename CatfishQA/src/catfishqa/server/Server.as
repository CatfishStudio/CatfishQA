package catfishqa.server 
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import catfishqa.json.JSON;
	import catfishqa.mysql.Query; 
		 
	public class Server
	{
		public static var client:String = "JGH37VB900D0IJ9D7VA027BA6";
		
		/* ПУТЬ К СЕРВЕРУ */
		public static var serverPath:String =  ""; //"http://localhost/cf/catfishqa/"; //"http://catfishstudio.besaba.com/catfishqa/";
		
		/* КОНСТАНТЫ */
		public static const SYSTEM_USERS:String = "system_users"; // имя таблицы (Системные пользователи)
		public static const SYSTEM_USERS_UPDATE:String = "system_users_update"; // событие обновления таблицы (Системные пользователи)
		public static const SYSTEM_USERS_NOT_UPDATE:String = "system_users_not_update"; // событие обновления таблицы (Системные пользователи)
		
		public static const TEAM_GROUPS:String = "team_groups"; // имя таблицы (Команда Группы)
		public static const TEAM_GROUPS_UPDATE:String = "team_groups_update"; // событие обновления таблицы (Команда Группы)
		public static const TEAM_GROUPS_NOT_UPDATE:String = "team_groups_not_update"; // событие обновления таблицы (Команда Группы)
		
		public static const TEAM_USERS:String = "team_users"; // имя таблицы
		public static const TEAM_USERS_UPDATE:String = "team_users_update"; // событие обновления таблицы
		public static const TEAM_USERS_NOT_UPDATE:String = "team_users_not_update"; // событие обновления таблицы
		
		public static const ROADMAP_SPRINTS:String = "roadmap_sprints"; // имя таблицы
		public static const ROADMAP_SPRINTS_UPDATE:String = "roadmap_sprints_update"; // событие обновления таблицы
		public static const ROADMAP_SPRINTS_NOT_UPDATE:String = "roadmap_sprints_not_update"; // событие обновления таблицы
		
		public static const ROADMAP_TASKS:String = "roadmap_tasks"; // имя таблицы
		public static const ROADMAP_TASKS_UPDATE:String = "roadmap_tasks_update"; // событие обновления таблицы
		public static const ROADMAP_TASKS_NOT_UPDATE:String = "roadmap_tasks_not_update"; // событие обновления таблицы
		
		public static const TESTPLAN_SPRINTS:String = "test_plan_sprints"; // имя таблицы
		public static const TESTPLAN_SPRINTS_UPDATE:String = "test_plan_sprints_update"; // событие обновления таблицы
		public static const TESTPLAN_SPRINTS_NOT_UPDATE:String = "test_plan_sprints_not_update"; // событие обновления таблицы
		
		public static const TESTPLAN_TASKS:String = "test_plan_tasks"; // имя таблицы
		public static const TESTPLAN_TASKS_UPDATE:String = "test_plan_tasks_update"; // событие обновления таблицы
		public static const TESTPLAN_TASKS_NOT_UPDATE:String = "test_plan_tasks_not_update"; // событие обновления таблицы
		
		
		/* ПОСЛЕНИЕ ОБНОВЛЕНИЯ */
		public static var last_update_system_users:String;
		public static var last_update_team_groups:String;
		public static var last_update_team_users:String;
		public static var last_update_roadmap_sprints:String;
		public static var last_update_roadmap_tasks:String;
		public static var last_update_testplan_sprints:String;
		public static var last_update_testplan_tasks:String;
		
		
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
			var _query:Query;
			
			if (tableName == SYSTEM_USERS)
			{
				_query = new Query();
				_query.performRequest(serverPath + "history_update_get.php?client=" + client + "&tableName=" + SYSTEM_USERS);
				_query.addEventListener("complete", onQuerySystemUsersComplete);
			}
			if (tableName == TEAM_GROUPS)
			{
				_query = new Query();
				_query.performRequest(serverPath + "history_update_get.php?client=" + client + "&tableName=" + TEAM_GROUPS);
				_query.addEventListener("complete", onQueryTeamGroupsComplete);
			}
			if (tableName == TEAM_USERS)
			{
				_query = new Query();
				_query.performRequest(serverPath + "history_update_get.php?client=" + client + "&tableName=" + TEAM_USERS);
				_query.addEventListener("complete", onQueryTeamUsersComplete);
			}
			if (tableName == ROADMAP_SPRINTS)
			{
				_query = new Query();
				_query.performRequest(serverPath + "history_update_get.php?client=" + client + "&tableName=" + ROADMAP_SPRINTS);
				_query.addEventListener("complete", onQueryRoadmapSprintsComplete);
			}
			if (tableName == ROADMAP_TASKS)
			{
				_query = new Query();
				_query.performRequest(serverPath + "history_update_get.php?client=" + client + "&tableName=" + ROADMAP_TASKS);
				_query.addEventListener("complete", onQueryRoadmapTasksComplete);
			}
			if (tableName == TESTPLAN_SPRINTS)
			{
				_query = new Query();
				_query.performRequest(serverPath + "history_update_get.php?client=" + client + "&tableName=" + TESTPLAN_SPRINTS);
				_query.addEventListener("complete", onQueryTestplanSprintsComplete);
			}
			if (tableName == TESTPLAN_TASKS)
			{
				_query = new Query();
				_query.performRequest(serverPath + "history_update_get.php?client=" + client + "&tableName=" + TESTPLAN_TASKS);
				_query.addEventListener("complete", onQueryTestplanTasksComplete);
			}
			
			
		}
		
		private static function onQuerySystemUsersComplete(event:Object):void 
		{
			var json_str:String = (event.target.getResult as String);
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
		
		private static function onQueryTeamGroupsComplete(event:Event):void 
		{
			var json_str:String = (event.target.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			
			if (json_data[0].table[0].history_update_name == TEAM_GROUPS)
			{
				if (json_data[0].table[0].history_update_datetime != last_update_team_groups) //нужно обновиться
				{
					last_update_team_groups = json_data[0].table[0].history_update_datetime;
					dispatchEvent(new ServerEvents(ServerEvents.TABLE_UPDATE, { id: TEAM_GROUPS_UPDATE }, true)); 
				}
				else
				{
					dispatchEvent(new ServerEvents(ServerEvents.TABLE_UPDATE, { id: TEAM_GROUPS_NOT_UPDATE }, true)); 
				}
			}
		}
		
		private static function onQueryTeamUsersComplete(event:Event):void 
		{
			var json_str:String = (event.target.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			
			if (json_data[0].table[0].history_update_name == TEAM_USERS)
			{
				if (json_data[0].table[0].history_update_datetime != last_update_team_users) //нужно обновиться
				{
					last_update_team_users = json_data[0].table[0].history_update_datetime;
					dispatchEvent(new ServerEvents(ServerEvents.TABLE_UPDATE, { id: TEAM_USERS_UPDATE }, true)); 
				}
				else
				{
					dispatchEvent(new ServerEvents(ServerEvents.TABLE_UPDATE, { id: TEAM_USERS_NOT_UPDATE }, true)); 
				}
			}
		}
		
		private static function onQueryRoadmapSprintsComplete(event:Event):void 
		{
			var json_str:String = (event.target.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			
			if (json_data[0].table[0].history_update_name == ROADMAP_SPRINTS)
			{
				if (json_data[0].table[0].history_update_datetime != last_update_roadmap_sprints) //нужно обновиться
				{
					last_update_roadmap_sprints = json_data[0].table[0].history_update_datetime;
					dispatchEvent(new ServerEvents(ServerEvents.TABLE_UPDATE, { id: ROADMAP_SPRINTS_UPDATE }, true)); 
				}
				else
				{
					dispatchEvent(new ServerEvents(ServerEvents.TABLE_UPDATE, { id: ROADMAP_SPRINTS_NOT_UPDATE }, true)); 
				}
			}
		}
		
		private static function onQueryRoadmapTasksComplete(event:Event):void 
		{
			var json_str:String = (event.target.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			
			if (json_data[0].table[0].history_update_name == ROADMAP_TASKS)
			{
				if (json_data[0].table[0].history_update_datetime != last_update_roadmap_tasks) //нужно обновиться
				{
					last_update_roadmap_tasks = json_data[0].table[0].history_update_datetime;
					dispatchEvent(new ServerEvents(ServerEvents.TABLE_UPDATE, { id: ROADMAP_TASKS_UPDATE }, true)); 
				}
				else
				{
					dispatchEvent(new ServerEvents(ServerEvents.TABLE_UPDATE, { id: ROADMAP_TASKS_NOT_UPDATE }, true)); 
				}
			}
		}
		
		private static function onQueryTestplanSprintsComplete(event:Event):void 
		{
			var json_str:String = (event.target.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			
			if (json_data[0].table[0].history_update_name == TESTPLAN_SPRINTS)
			{
				if (json_data[0].table[0].history_update_datetime != last_update_testplan_sprints) //нужно обновиться
				{
					last_update_testplan_sprints = json_data[0].table[0].history_update_datetime;
					dispatchEvent(new ServerEvents(ServerEvents.TABLE_UPDATE, { id: TESTPLAN_SPRINTS_UPDATE }, true)); 
				}
				else
				{
					dispatchEvent(new ServerEvents(ServerEvents.TABLE_UPDATE, { id: TESTPLAN_SPRINTS_NOT_UPDATE }, true)); 
				}
			}
		}
		
		private static function onQueryTestplanTasksComplete(event:Event):void 
		{
			var json_str:String = (event.target.getResult as String);
			var json_data:Array = catfishqa.json.JSON.decode(json_str); 
			
			if (json_data[0].table[0].history_update_name == TESTPLAN_TASKS)
			{
				if (json_data[0].table[0].history_update_datetime != last_update_testplan_tasks) //нужно обновиться
				{
					last_update_testplan_tasks = json_data[0].table[0].history_update_datetime;
					dispatchEvent(new ServerEvents(ServerEvents.TABLE_UPDATE, { id: TESTPLAN_TASKS_UPDATE }, true)); 
				}
				else
				{
					dispatchEvent(new ServerEvents(ServerEvents.TABLE_UPDATE, { id: TESTPLAN_TASKS_NOT_UPDATE }, true)); 
				}
			}
		}
		
		
		
		
		/*=========================================================================================*/
	}

}