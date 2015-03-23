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
		
		public static const ADMIN:String = "admin";
		public static const CLIENT:String = "client";
	}

}