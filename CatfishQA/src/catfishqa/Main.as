package catfishqa
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	
	import fl.controls.Button;
	import fl.controls.TextInput;
	import fl.controls.ComboBox;
	import fl.controls.Label;
	import fl.data.DataProvider; 
	import fl.events.ComponentEvent;
	
	import catfishqa.background.GradientBG;
	import catfishqa.resource.Resource;
	import catfishqa.events.Navigation;
	import catfishqa.windows.MessageBox;
	
	import catfishqa.login.Login;
	import catfishqa.admin.Admin;
	import catfishqa.client.Client;
	
	import catfishqa.server.Server;
	import catfishqa.windows.UserLogin;
	import catfishqa.windows.SystemFilePath;
	import catfishqa.admin.systemUsers.SystemUser;
	import catfishqa.admin.team.Team;
	import catfishqa.admin.roadmap.Roadmap;
	import catfishqa.admin.testplan.TestPlan;
	
	public class Main extends Sprite 
	{
		private var _gradientBG:GradientBG;
		
		private var _login:Login;
		private var _systemFilePath:SystemFilePath;
		
		private var _admin:Admin;
		private var _systemUsers:SystemUser;
		private var _team:Team;
		private var _roadmap:Roadmap;
		private var _testplan:TestPlan;
		
		private var _client:Client;
		
		
		public function Main() 
		{
			addEventListener(Navigation.CHANGE_SCREEN, onChangeScreen);
			stage.nativeWindow.addEventListener(Event.RESIZE, onNativeWindowResize);
			
			ShowBackground();
			
			if (SystemFile() == true) LoginShow();
			else SystemFilePathShow();
		}
		
		private function onNativeWindowResize(e:Event):void 
		{
			if (_gradientBG != null)
			{
				if (_gradientBG.w < stage.nativeWindow.width) _gradientBG.x = (_gradientBG.w - stage.nativeWindow.width) / 2;
				else _gradientBG.x = 0;
				_gradientBG.w = stage.nativeWindow.width;
				_gradientBG.h = stage.nativeWindow.height;
				_gradientBG.Update();
			}
		}
		
		private function ShowBackground():void
		{
			_gradientBG = new GradientBG(stage.nativeWindow.width, stage.nativeWindow.height);
			addChild(_gradientBG);
			
			var bitmapQA:Bitmap = new Resource.ImageQA();
			bitmapQA.smoothing = true;
			bitmapQA.x = 350;
			bitmapQA.y = 50;
			addChild(bitmapQA);
			bitmapQA = null;
			
		}
		
		private function SystemFile():Boolean
		{
			//var file:File = File.documentsDirectory.resolvePath("path_qa.txt");
			var file:File = File.desktopDirectory.resolvePath("path_qa.txt");
			if (file.exists == false)
			{
				var streamW:FileStream = new FileStream();
				streamW.open(file, FileMode.WRITE);
				streamW.writeUTFBytes("http://localhost/cf/catfishqa/");
				streamW.close();
				
				return false;
			}else {
				var streamR:FileStream = new FileStream();
				streamR.open(file, FileMode.READ);
				Server.serverPath = streamR.readUTFBytes(file.size);
				streamR.close();
			}
			
			return true;
		}
		
		private function LoginShow():void
		{
			_login = new Login();
			_login.x = 270;
			_login.y = 100;
			addChild(_login);
		}
		
		private function LoginClose():void
		{
			if(getChildByName(Resource.LOGIN)) removeChild(_login);
		}
		
		private function SystemFilePathShow():void
		{
			_systemFilePath = new SystemFilePath();
			_systemFilePath.addEventListener(Event.CLOSE, onSystemFilePathClose);
			_systemFilePath.x = 260;
			_systemFilePath.y = 25;
			addChild(_systemFilePath);
		}
		
		private function onSystemFilePathClose(event:Event):void
		{
			_systemFilePath.removeEventListener(Event.CLOSE, onSystemFilePathClose);
			
			//var file:File = File.documentsDirectory.resolvePath("path_qa.txt");
			var file:File = File.desktopDirectory.resolvePath("path_qa.txt");
			if (file.exists == true)
			{
				var streamW:FileStream = new FileStream();
				streamW.open(file, FileMode.READ);
				Server.serverPath = streamW.readUTFBytes(file.size);
				streamW.close();
			}
			
			SystemFilePathClose();
			LoginShow();
		}
		
		private function SystemFilePathClose():void
		{
			if(getChildByName(Resource.PATH)) removeChild(_systemFilePath);
		}
		
		
		private function AdminShow():void
		{
			_admin = new Admin();
			addChild(_admin);
		}
		
		private function AdminClose():void
		{
			if(getChildByName(Resource.ADMIN)) removeChild(_admin);
		}
		
		private function ClientShow():void
		{
			_client = new Client();
			addChild(_client);
		}
		
		private function ClientClose():void
		{
			if(getChildByName(Resource.CLIENT)) removeChild(_client);
		}
		
		
		private function SystemUsersShow():void
		{
			_systemUsers = new SystemUser();
		}
		
		private function TeamShow():void
		{
			_team = new Team();
		}
		
		private function RoadmapShow():void
		{
			_roadmap = new Roadmap();
		}
		
		private function TestplanShow():void
		{
			_testplan = new TestPlan();
		}
		
		private function onChangeScreen(event:Navigation):void 
		{
			switch(event.param.id)
			{
				case Resource.ADMIN: 
				{
					LoginClose();
					AdminShow();
					Resource.myStatus = Resource.ADMIN;
					break;
				}
				
				case Resource.SYSTEM_USERS: 
				{
					SystemUsersShow();
					break;
				}
				
				case Resource.TEAM: 
				{
					TeamShow();
					break;
				}
				
				case Resource.ROADMAP: 
				{
					RoadmapShow();
					break;
				}
				
				case Resource.TEST_PLAN: 
				{
					TestplanShow();
					break;
				}
				
				case Resource.CLIENT: 
				{
					LoginClose();
					ClientShow();
					Resource.myStatus = Resource.USER;
					break;
				}
				
				
				
				case Resource.EXIT_SYSTEM: 
				{
					AdminClose();
					ClientClose();
					LoginShow();
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