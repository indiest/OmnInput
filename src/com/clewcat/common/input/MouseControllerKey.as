package com.clewcat.common.input 
{
	/**
	 * ...
	 * @author Nicolas Tian
	 */
	public class MouseControllerKey extends ControllerKey 
	{
		public function MouseControllerKey(name:String, autoRelease:Boolean) 
		{
			super(name, autoRelease);
		}
		
		public static const LEFT_BUTTON:MouseControllerKey = new MouseControllerKey("MOUSE LEFT BUTTON", false);
		public static const MOVE_LEFT:MouseControllerKey = new MouseControllerKey("MOUSE MOVE LEFT", true);
		public static const MOVE_RIGHT:MouseControllerKey = new MouseControllerKey("MOUSE MOVE RIGHT", true);
		public static const MOVE_UP:MouseControllerKey = new MouseControllerKey("MOUSE MOVE UP", true);
		public static const MOVE_DOWN:MouseControllerKey = new MouseControllerKey("MOUSE MOVE DOWN", true);
		public static const DRAG_LEFT:MouseControllerKey = new MouseControllerKey("MOUSE DRAG LEFT", true);
		public static const DRAG_RIGHT:MouseControllerKey = new MouseControllerKey("MOUSE DRAG RIGHT", true);
		public static const DRAG_UP:MouseControllerKey = new MouseControllerKey("MOUSE DRAG UP", true);
		public static const DRAG_DOWN:MouseControllerKey = new MouseControllerKey("MOUSE DRAG DOWN", true);
		
		public static function fromX(x:Number, buttonDown:Boolean):MouseControllerKey
		{
			if (buttonDown)
			{
				return x > 0 ? DRAG_RIGHT : DRAG_LEFT;
			}
			else
			{
				return x > 0 ? MOVE_RIGHT : MOVE_LEFT;
			}
		}
		
		public static function fromY(y:Number, buttonDown:Boolean):MouseControllerKey
		{
			if (buttonDown)
			{
				return y > 0 ? DRAG_DOWN : DRAG_UP;
			}
			else
			{
				return y > 0 ? MOVE_DOWN : MOVE_UP;
			}
		}
	}

}