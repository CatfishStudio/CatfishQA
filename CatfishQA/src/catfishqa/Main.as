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
	import catfishqa.events.Navigation;
	
	import catfishqa.login.Login;
	import catfishqa.admin.Admin;
	import catfishqa.client.Client;
	
	import catfishqa.windows.UserLogin;
	import catfishqa.admin.systemUsers.SystemUser;
	import catfishqa.admin.team.Team;
	
	public class Main extends Sprite 
	{
		private var _login:Login;
		
		private var _admin:Admin;
		private var _systemUsers:SystemUser;
		private var _team:Team;
		
		private var _client:Client;
		
		
		public function Main() 
		{
			addEventListener(Navigation.CHANGE_SCREEN, onChangeScreen);
			
			ShowBackground();
			
			LoginShow()
			
			//_userLogin = new UserLogin();
		}
		
		private function ShowBackground():void
		{
			var bitmapBG:Bitmap = new Resource.ImageBackground();
			bitmapBG.smoothing = true;
			addChild(bitmapBG);
			bitmapBG = null;
		}
		
		private function LoginShow():void
		{
			_login = new Login();
			_login.x = 260;
			_login.y = 25;
			addChild(_login);
		}
		
		private function LoginClose():void
		{
			if(getChildByName(Resource.LOGIN)) removeChild(_login);
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