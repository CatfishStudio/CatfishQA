package catfishqa.systemUsers 
{
	import fl.controls.Button;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;
	import flash.events.Event;  
    import flash.events.MouseEvent; 
	
	import catfishqa.server.Server;
	
	public class ButtonCellEdit extends Button implements ICellRenderer 
	{
		private var _listData:ListData;  
        private var _data:Object;  
		
		public function ButtonCellEdit() 
		{
			super();
			label = "Изменить.";
			addEventListener(MouseEvent.CLICK, onButtonClick); 
		}
		
		public function set data(d:Object):void  
        {  
            _data = d;  
        }  
          
        public function get data():Object  
        {  
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