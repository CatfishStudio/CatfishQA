package catfishqa.admin 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import fl.controls.Button;
	import fl.controls.TextInput;
	import fl.controls.ComboBox;
	import fl.controls.Label;
	import fl.data.DataProvider; 
	import fl.events.ComponentEvent;
	
	import catfishqa.events.Navigation;
	import catfishqa.resource.Resource;
	
	
	public class Admin extends Sprite 
	{
		private var _background:Sprite = new Sprite();
		
		private var _button1:Button = new Button();
		private var _label1:Label = new Label();
		
		private var _button2:Button = new Button();
		private var _label2:Label = new Label();
		
		private var _button3:Button = new Button();
		private var _label3:Label = new Label();
		
		private var _button4:Button = new Button();
		private var _label4:Label = new Label();
		
		private var _button5:Button = new Button();
		private var _label5:Label = new Label();
		
		private var _button6:Button = new Button();
		private var _label6:Label = new Label();
		
		private var _button7:Button = new Button();
		private var _label7:Label = new Label();
		
		private var _button8:Button = new Button();
		private var _label8:Label = new Label();
		
		private var _button9:Button = new Button();
		private var _label9:Label = new Label();
		
		public function Admin() 
		{
			super();
			name = Resource.ADMIN;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			adminShow();
		}
		
		private function adminShow():void
		{
			_background.graphics.lineStyle(1,0xffffff);
			_background.graphics.beginFill(0xffffff);
			_background.graphics.drawRect(10,50,780,500);
			_background.graphics.endFill();
			_background.alpha = 0.2;
			addChild(_background);
			
			_button1.label = "Пользователи";
			_button1.x = 20; _button1.y = 155;
			_button1.width = 200;
			_button1.addEventListener(MouseEvent.CLICK, onButton1MouseClick);
			addChild(_button1);
			
			_label1.text = "Пользователи - раздел пользователей данной системы. \nВы можете добавлять, изменять и удалять системных пользователей в этом разделе."; 
			_label1.x = 250; _label1.y = 150;
			_label1.width = 500;
			_label1.height = 100;
			_label1.setStyle("textFormat", new TextFormat("Arial", 12, 0xffffff));
			addChild(_label1);
			
			_button2.label = "Проекты и команды";
			_button2.x = 20; _button2.y = 195;
			_button2.width = 200;
			_button2.addEventListener(MouseEvent.CLICK, onButton2MouseClick);
			addChild(_button2);
			
			_label2.text = "Раздел активных проектов и входещая в неё команда сотрудников. \nКаждому проекту соответствует своя группа сотрудников, тест-кейсы, чек-листы и прочее."; 
			_label2.x = 250; _label2.y = 190;
			_label2.width = 550;
			_label2.height = 100;
			_label2.setStyle("textFormat", new TextFormat("Arial", 12, 0xffffff));
			addChild(_label2);
			
			_button3.label = "Роадмап";
			_button3.x = 20; _button3.y = 235;
			_button3.width = 200;
			_button3.addEventListener(MouseEvent.CLICK, onButton3MouseClick);
			addChild(_button3);
			
			_label3.text = "Роадмап - раздел запланированных спринтов. \nВ данном разделе вы можете ознакомиться с процессом выполнения определённого спринта."; 
			_label3.x = 250; _label3.y = 230;
			_label3.width = 500;
			_label3.height = 100;
			_label3.setStyle("textFormat", new TextFormat("Arial", 12, 0xffffff));
			addChild(_label3);
			
			_button4.label = "Тест-план";
			_button4.x = 20; _button4.y = 275;
			_button4.width = 200;
			_button4.addEventListener(MouseEvent.CLICK, onButton4MouseClick);
			addChild(_button4);
			
			_label4.text = "Тест-план - раздел описания четкого плана на определённый спринт. \nВ данном разделе содержится информация о тех задачах которые необходимо выполнить на текущий спринт."; 
			_label4.x = 250; _label4.y = 270;
			_label4.width = 500;
			_label4.height = 100;
			_label4.setStyle("textFormat", new TextFormat("Arial", 12, 0xffffff));
			addChild(_label4);
			
			_button5.label = "Чек-листы";
			_button5.x = 20; _button5.y = 315;
			_button5.width = 200;
			_button5.addEventListener(MouseEvent.CLICK, onButton5MouseClick);
			addChild(_button5);
			
			_label5.text = "Чек-листы - раздел чек-листов относительно проекта. \nДанный раздел содержит перечень чек-листов определённого проекта."; 
			_label5.x = 250; _label5.y = 310;
			_label5.width = 500;
			_label5.height = 100;
			_label5.setStyle("textFormat", new TextFormat("Arial", 12, 0xffffff));
			addChild(_label5);
			
			_button6.label = "Тест-кейсы";
			_button6.x = 20; _button6.y = 355;
			_button6.width = 200;
			_button6.addEventListener(MouseEvent.CLICK, onButton6MouseClick);
			addChild(_button6);
			
			_label6.text = "Тест-кейсы - раздел тест-кейсов относительно пунктов чек-листа. \nДанный раздел содержит перечень тест-кейсов определённых пунктов чек-листа."; 
			_label6.x = 250; _label6.y = 350;
			_label6.width = 500;
			_label6.height = 100;
			_label6.setStyle("textFormat", new TextFormat("Arial", 12, 0xffffff));
			addChild(_label6);
			
			_button7.label = "Тикеты";
			_button7.x = 20; _button7.y = 395;
			_button7.width = 200;
			_button7.addEventListener(MouseEvent.CLICK, onButton7MouseClick);
			addChild(_button7);
			
			_label7.text = "Тикеты - раздел содержит перечень тикетов. \nВ данном разделе содержатся тикеты определённого пункта чек-листа."; 
			_label7.x = 250; _label7.y = 390;
			_label7.width = 500;
			_label7.height = 100;
			_label7.setStyle("textFormat", new TextFormat("Arial", 12, 0xffffff));
			addChild(_label7);
			
			_button8.label = "Отчеты";
			_button8.x = 20; _button8.y = 435;
			_button8.width = 200;
			_button8.addEventListener(MouseEvent.CLICK, onButton8MouseClick);
			addChild(_button8);
			
			_label8.text = "Отчеты - "; 
			_label8.x = 250; _label8.y = 430;
			_label8.width = 500;
			_label8.height = 100;
			_label8.setStyle("textFormat", new TextFormat("Arial", 12, 0xffffff));
			addChild(_label8);
			
			_button9.label = "Выйти из системы";
			_button9.x = 20; _button9.y = 500;
			_button9.width = 200;
			_button9.addEventListener(MouseEvent.CLICK, onButton9MouseClick);
			addChild(_button9);
			
			
		}
		
		private function onButton1MouseClick(e:MouseEvent):void 
		{
			dispatchEvent(new Navigation(Navigation.CHANGE_SCREEN, { id: Resource.SYSTEM_USERS }, true));
		}
		
		private function onButton2MouseClick(e:MouseEvent):void 
		{
			dispatchEvent(new Navigation(Navigation.CHANGE_SCREEN, { id: Resource.TEAM }, true));
		}
		
		private function onButton3MouseClick(e:MouseEvent):void 
		{
			dispatchEvent(new Navigation(Navigation.CHANGE_SCREEN, { id: Resource.ROADMAP }, true));
		}
		
		private function onButton4MouseClick(e:MouseEvent):void 
		{
			
		}
		
		private function onButton5MouseClick(e:MouseEvent):void 
		{
			
		}
		
		private function onButton6MouseClick(e:MouseEvent):void 
		{
			
		}
		
		private function onButton7MouseClick(e:MouseEvent):void 
		{
			
		}
		
		private function onButton8MouseClick(e:MouseEvent):void 
		{
			
		}
				
		private function onButton9MouseClick(e:MouseEvent):void 
		{
			dispatchEvent(new Navigation(Navigation.CHANGE_SCREEN, { id: Resource.EXIT_SYSTEM }, true));
		}
		
		
	}

}