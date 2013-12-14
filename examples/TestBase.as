package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Nicolas Tian
	 */
	public class TestBase extends Sprite 
	{
		private var _lastTickTime:int;
		
		public function TestBase() 
		{
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			_lastTickTime = getTimer();
			
		}
		
		private function handleEnterFrame(e:Event):void 
		{
			var tickTime:int = getTimer();
			update((tickTime - _lastTickTime) * 0.001);
			_lastTickTime = tickTime;
		}
		
		public function update(deltaSecond:Number):void 
		{
			
		}
		
	}

}