package catfishqa.resource 
{
	import flash.display.Bitmap;
	
	/**
	 * ...
	 * @author Catfish Studio Games
	 */
	
	public class Resource 
	{
		[Embed(source = '../../../images/background.png')]
		public static var ImageBackground:Class;
				
		public static var server:String = "http://localhost/cf/catfishqa/"; //"http://catfishstudio.besaba.com/catfishqa/";
		
		public static const LOGIN:String = "login";
		public static const ADMIN:String = "admin";
		public static const CLIENT:String = "client";
		public static const EXIT_SYSTEM:String = "exitSystem";
		public static const SYSTEM_USERS:String = "systemUsers";
		
		/* Таблица базы данных system_users */
		public static var systemUsersArray:Array = []; 
		
	}

}