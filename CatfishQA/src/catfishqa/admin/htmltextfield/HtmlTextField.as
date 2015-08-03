package catfishqa.admin.htmltextfield 
{
	import flash.text.TextField;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;
	import flash.events.Event;  
    import flash.events.MouseEvent;
	
	public class HtmlTextField extends TextField implements ICellRenderer 
	{
		private var _listData:ListData;  
        private var _data:Object; 
		private var _selected:Boolean;
		
		public function HtmlTextField() 
		{
			super();
			
		}
		
		public function set data(d:Object):void  
        {  
            _data = d;
			this.text = "";
			this.htmlText = _data.Статус;
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
		
		public function get selected():Boolean   
        {  
            return _selected;  
        }  
  
        public function set selected(value:Boolean):void   
        {  
              
        }  
        
		public function setSize(width:Number, height:Number):void
		{
			
		}
		
		public function setMouseState(state:String):void
		{
			
		}
		
		
	}

}