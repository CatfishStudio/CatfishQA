package catfishqa
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	
	import fl.controls.Button;
	import fl.controls.TextInput;
	import fl.controls.ComboBox;
	import fl.controls.Label;
	import fl.data.DataProvider; 
	import fl.events.ComponentEvent;
	
	import catfishqa.resource.Resource;
	import catfishqa.windows.UserLogin;
	import catfishqa.login.Login;
	
	/**
	 * ...
	 * @author Catfish Studio Games
	 */
	public class Main extends Sprite 
	{
		private var _userLogin:UserLogin;
		private var _login:Login;
		
		
		public function Main() 
		{
			ShowBackground();
			
			_login = new Login();
			_login.x = 260;
			_login.y = 25;
			addChild(_login);
			
			//_userLogin = new UserLogin();
		}
		
		private function ShowBackground():void
		{
			var bitmapBG:Bitmap = new Resource.ImageBackground();
			bitmapBG.smoothing = true;
			addChild(bitmapBG);
			bitmapBG = null;
		}
		
	}
	
}