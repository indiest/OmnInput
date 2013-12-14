package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import com.clewcat.common.input.ControllerKey;
	import com.clewcat.common.input.KeyboardController;
	import com.clewcat.common.input.KeyboardControllerKey;
	
	/**
	 * ...
	 * @author Nicolas Tian
	 */
	public class KeyboardControllerTest extends TestBase 
	{
		private var _kc:KeyboardController;
		
		public function KeyboardControllerTest() 
		{
			_kc = new KeyboardController(stage);
			_kc.keyDownEvent.add(function(key:KeyboardControllerKey, pressure:Number = 1):void
			{
				trace("KeyDown Event:", key.keyCode, key.name);
			});
			_kc.keyUpEvent.add(function(key:KeyboardControllerKey, pressure:Number = 0):void
			{
				trace("KeyUp Event:", key.keyCode, key.name);
			});
			
			stage.addEventListener(MouseEvent.CLICK, handleClick);
		}
		
		private function handleClick(e:MouseEvent):void 
		{
			_kc.enabled = !_kc.enabled;
			trace("Enabled:", _kc.enabled);
		}
		
		override public function update(deltaSecond:Number):void 
		{
			_kc.update(deltaSecond);
			if (_kc.isKeyDown(KeyboardControllerKey.fromKeyCode(Keyboard.SPACE)))
			{
				trace("SPACE keydown:", 
					_kc.isKeyDown(ControllerKey.fromName("SPACE")));
			}
			if (_kc.isKeyUp(KeyboardControllerKey.fromKeyCode(Keyboard.SPACE)))
			{
				trace("SPACE keyup:", 
					_kc.isKeyUp(ControllerKey.fromName("SPACE")));
			}
		}
		
	}

}