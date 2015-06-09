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
		[Embed(source = '../../../images/group.png')]
		public static var ImageGroupUserIcon:Class;
		[Embed(source = '../../../images/user.png')]
		public static var ImageUserIcon:Class;
				
		public static const LOGIN:String = "login";
		public static const ADMIN:String = "admin";
		public static const USER:String = "user";
		public static const CLIENT:String = "client";
		public static const EXIT_SYSTEM:String = "exitSystem";
		public static const PATH:String = "path";
		
		public static const SYSTEM_USERS:String = "systemUsers"; // окно системные пользователи
		public static const TEAM:String = "team"; // окно команды (группы пользователей)
		
		/* ПРАВА ПОЛЬЗОВАТЕЛЯ */
		public static var myStatus:String = "";
	}

}