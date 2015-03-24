package catfishqa.events 
{
	import flash.events.Event;
	
	public class Navigation extends Event 
	{
		public static const CHANGE_SCREEN:String = "changeScreen";
		public var param:Object;
		
		public function Navigation(type:String, _params:Object = null, bubbles:Boolean=false) 
		{
			super(type, bubbles);
			this.param = _params;
		}
		
	}

}