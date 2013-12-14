package com.clewcat.common.input
{
	import flash.utils.Dictionary;
	import me.sangtian.common.util.ObjectUtil;
	import org.gestouch.gestures.Gesture;
	import org.gestouch.gestures.SwipeGesture;
	import org.gestouch.gestures.SwipeGestureDirection;
	import org.gestouch.gestures.TapGesture;
	
	/**
	 * ...
	 * @author Nicolas Tian
	 */
	public class GestouchControllerKey extends ControllerKey
	{
		private var _gesture:Gesture;
		
		public function get gesture():Gesture
		{
			return _gesture;
		}
		
		public function GestouchControllerKey(name:String, autoRelease:Boolean, gesture:Gesture)
		{
			super(name, autoRelease);
			_gesture = gesture;
			_gestureKeyMapping[gesture] = this;
		}
		
		/*
		override public function equals(otherKey:ControllerKey):Boolean 
		{
			if (!(otherKey is GestouchControllerKey))
				return false;
			var key:GestouchControllerKey = otherKey as GestouchControllerKey;
			return key.gesture.target === _gesture.target &&
				key.gesture.reflect() === _gesture.reflect();
		}
		*/
		
		//public static const SWIPE_LEFT:GestouchControllerKey = new GestouchControllerKey("SWIPE LEFT", ObjectUtil.applyProperties(new SwipeGesture(), {direction: SwipeGestureDirection.LEFT}));
		//public static const SWIPE_RIGHT:GestouchControllerKey = new GestouchControllerKey("SWIPE RIGHT", ObjectUtil.applyProperties(new SwipeGesture(), {direction: SwipeGestureDirection.RIGHT}));
		//public static const SWIPE_UP:GestouchControllerKey = new GestouchControllerKey("SWIPE UP", ObjectUtil.applyProperties(new SwipeGesture(), {direction: SwipeGestureDirection.UP}));
		//public static const SWIPE_DOWN:GestouchControllerKey = new GestouchControllerKey("SWIPE DOWN", ObjectUtil.applyProperties(new SwipeGesture(), {direction: SwipeGestureDirection.DOWN}));
		//public static const TAP:GestouchControllerKey = new GestouchControllerKey("TAP", ObjectUtil.applyProperties(new TapGesture(), {numTapsRequired: 1}));
		//public static const DOUBLE_TAP:GestouchControllerKey = new GestouchControllerKey("DOUBLE TAP", ObjectUtil.applyProperties(new TapGesture(), {numTapsRequired: 2}));
		
		private static var _gestureKeyMapping:Dictionary = new Dictionary();
		
		public static function fromGesture(gesture:Gesture):GestouchControllerKey
		{
			return _gestureKeyMapping[gesture];
		}
	}

}