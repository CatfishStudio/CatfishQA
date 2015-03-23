package catfishqa.windows 
{
	import flash.display.NativeWindow; 
	import flash.display.NativeWindowDisplayState;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import flash.html.HTMLLoader;
	import flash.net.URLRequest;
	
	import catfishqa.resource.Resource;
	
	/**
	 * ...
	 * @author Catfish Studio Games
	 */
	
	 public class UserLogin extends NativeWindowInitOptions 
	{
		private var _htmlLoader: HTMLLoader;
		
		public function UserLogin() 
		{
			super();
			
			transparent = false; 
			systemChrome = NativeWindowSystemChrome.STANDARD; 
			type = NativeWindowType.NORMAL; 
     
			//create the window 
			var newWindow:NativeWindow = new NativeWindow(this); 
			newWindow.title = "A title"; 
			newWindow.width = 600; 
			newWindow.height = 400; 
			newWindow.alwaysInFront = true; // всегда поверх других окон
			
			newWindow.stage.align = StageAlign.TOP_LEFT; 
			newWindow.stage.scaleMode = StageScaleMode.NO_SCALE; 
 
			
			_htmlLoader = new HTMLLoader();
			_htmlLoader.width = newWindow.stage.stageWidth;
			_htmlLoader.height = newWindow.stage.stageHeight;
			newWindow.stage.addChild(_htmlLoader);
			_htmlLoader.load(new URLRequest(Resource.server + "users.php"));
			
			//activate and show the new window 
			newWindow.activate(); 
		}
		
	}

}