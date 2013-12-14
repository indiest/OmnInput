package 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import com.clewcat.common.input.ControllerKey;
	import com.clewcat.common.input.GestouchController;
	import com.clewcat.common.input.GestouchControllerKey;
	import com.clewcat.common.input.InputAction;
	import com.clewcat.common.input.InputManager;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.SwipeGesture;
	import org.gestouch.gestures.TapGesture;
	
	/**
	 * ...
	 * @author Nicolas Tian
	 */
	public class GestouchControllerTest extends TestBase 
	{
		private var _gc:GestouchController;
		private var _im:InputManager;
		
		public function GestouchControllerTest() 
		{
			_gc = new GestouchController(stage);
			_gc.addKey(_gc.DOUBLE_TAP);
			_gc.addKey(_gc.SWIPE_LEFT);
			_gc.addKey(_gc.SWIPE_RIGHT);
			_gc.addKey(_gc.SWIPE_UP);
			_gc.addKey(_gc.SWIPE_DOWN);
			_gc.keyUpEvent.add(function(key:GestouchControllerKey):void
			{
				trace("Key Up:", key);
				if (key.name.indexOf("Swipe") == 0)
				{
					var swipeGesture:SwipeGesture = key.gesture as SwipeGesture;
					trace("Offset:", swipeGesture.offsetX, swipeGesture.offsetY);
				}
			});
			
			_im = new InputManager();
			for (var i:int = 1; i < 5; i++)
			{
				var button:Sprite = new Sprite();
				button.name = "button" + i;
				button.graphics.beginFill(0xffff00);
				button.graphics.drawCircle(0, 0, 50);
				button.graphics.endFill();
				button.x = 180;
				button.y = i * 120;
				var gc:GestouchController = new GestouchController(button);
				//gc.addKey(GestouchControllerKey.TAP);
				_im.addController(gc).addAction(
					new InputAction("Tab Button" + i,
						Vector.<ControllerKey>([gc.addKey(gc.TAP)]),
						0, 0, true
					));
				addChild(button);
			}
			_gc.keyDownEvent.add(function(key:GestouchControllerKey, pressure:Number):void
			{
				trace("Key Down:", key, key.gesture.target, pressure);
			});
			
			//_im.addAction(new InputAction("Tab Button", Vector.<ControllerKey>([GestouchControllerKey.TAP]));
			_im.actionEvent.add(function(action:InputAction):void
			{
				trace("Action:", action.id);
			});
		}
		
		override public function update(deltaSecond:Number):void 
		{
			_im.update(deltaSecond);
		}
	}

}