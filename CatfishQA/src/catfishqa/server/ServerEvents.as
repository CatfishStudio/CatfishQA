package catfishqa.server 
{
	import flash.events.Event;
	
	public class ServerEvents extends Event 
	{
		public static const TABLE_UPDATE:String = "tableUpdate";
		public var param:Object;
		
		public function ServerEvents(type:String, _params:Object = null, bubbles:Boolean=false) 
		{
			super(type, bubbles);
			this.param = _params;
		}
		
	}

}