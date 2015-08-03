package catfishqa.admin.buttons 
{
	import fl.controls.Button;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;
	import flash.events.Event;  
    import flash.events.MouseEvent; 
	
	import catfishqa.server.Server;
	
	public class ButtonCellOpenLink extends Button implements ICellRenderer 
	{
		private var _listData:ListData;  
        private var _data:Object;  
		
		public function ButtonCellOpenLink() 
		{
			super();
			label = "Открыть.";
			addEventListener(MouseEvent.CLICK, onButtonClick); 
		}
		
		public function set data(d:Object):void  
        {  
            _data = d;  
			
        }  
          
        public function get data():Object  
        {  
			/*
			for(var prop:String in _data)
			{
				trace(prop + ":" + _data[prop]);
			}
			*/
			
			//trace(_data.Ссылка);
			return _data;  
        }  
          
        public function get listData():ListData  
        {  
            return _listData;  
        }  
          
        public function set listData(value:ListData):void   
        {  
            _listData = value;  
        }  
  
        override public function get selected():Boolean   
        {  
            return _selected;  
        }  
  
        override public function set selected(value:Boolean):void   
        {  
              
        }  
          
        public function onButtonClick(event:MouseEvent):void 
        {  
            //событие
        }  
		
	}

}