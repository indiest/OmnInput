package com.clewcat.common.input 
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Nicolas Tian
	 */
	public class KeyboardController extends Controller 
	{
		
		
		public function KeyboardController(stage:Stage) 
		{
			//KeyboardControllerKey.cacheKeyboardKeys();
			super("Keyboard");
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
		}
		
		private function handleKeyDown(e:KeyboardEvent):void 
		{
			if (!enabled)
				return;
			var key:KeyboardControllerKey = KeyboardControllerKey.fromKeyCode(e.keyCode);
			onKeyDown(key);
		}
		
		private function handleKeyUp(e:KeyboardEvent):void 
		{
			if (!enabled)
				return;
			var key:KeyboardControllerKey = KeyboardControllerKey.fromKeyCode(e.keyCode);
			onKeyUp(key);
		}
	}

}