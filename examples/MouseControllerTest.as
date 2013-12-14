package 
{
	import flash.display.Sprite;
	import com.clewcat.common.input.MouseController;
	import com.clewcat.common.input.MouseControllerKey;
	
	/**
	 * ...
	 * @author Nicolas Tian
	 */
	public class MouseControllerTest extends TestBase 
	{
		private var _mc:MouseController;
		
		public function MouseControllerTest() 
		{
			_mc = new MouseController(stage);
			_mc.keyDownEvent.add(function(key:MouseControllerKey, value:Number = 1):void
			{
				trace(key, value);
			});
		}
		
		override public function update(deltaSecond:Number):void 
		{
			_mc.update(deltaSecond);
			if (_mc.isKeyDown(MouseControllerKey.LEFT_BUTTON))
			{
				trace("Dragging x,y:", _mc.isKeyDown(MouseControllerKey.DRAG_RIGHT),
					_mc.isKeyDown(MouseControllerKey.DRAG_DOWN));
			}
		}
	}

}