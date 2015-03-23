package catfishqa.mysql 
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Catfish Studio Games
	 */
	
	public class Query extends URLLoader 
	{
		private var result:*;
		
		public function Query() 
		{
			super();
			
		}
		
		public function performRequest(filePHP:String):void
		{
			var request:URLRequest = new URLRequest(filePHP);
			addEventListener(Event.COMPLETE, onComplete);
			load(request);
		}


		private function onComplete(e:Event):void
		{
			result = data;
		}
		
		public function get getResult():*
		{
			return result;
		}


	}

}