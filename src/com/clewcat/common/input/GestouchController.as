package com.clewcat.common.input 
{
	import flash.utils.Dictionary;
	import me.sangtian.common.util.ObjectUtil;
	import org.gestouch.core.Gestouch;
	import org.gestouch.core.GestureState;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.Gesture;
	import org.gestouch.gestures.SwipeGesture;
	import org.gestouch.gestures.SwipeGestureDirection;
	import org.gestouch.gestures.TapGesture;
	/**
	 * ...
	 * @author Nicolas Tian
	 */
	public class GestouchController extends Controller 
	{
		public const SWIPE_LEFT:GestouchControllerKey = new GestouchControllerKey("SWIPE LEFT", true, ObjectUtil.applyProperties(new SwipeGesture(), {direction: SwipeGestureDirection.LEFT}));
		public const SWIPE_RIGHT:GestouchControllerKey = new GestouchControllerKey("SWIPE RIGHT", true, ObjectUtil.applyProperties(new SwipeGesture(), {direction: SwipeGestureDirection.RIGHT}));
		public const SWIPE_UP:GestouchControllerKey = new GestouchControllerKey("SWIPE UP", true, ObjectUtil.applyProperties(new SwipeGesture(), {direction: SwipeGestureDirection.UP}));
		public const SWIPE_DOWN:GestouchControllerKey = new GestouchControllerKey("SWIPE DOWN", true, ObjectUtil.applyProperties(new SwipeGesture(), {direction: SwipeGestureDirection.DOWN}));
		public const TAP:GestouchControllerKey = new GestouchControllerKey("TAP", true, ObjectUtil.applyProperties(new TapGesture(), {numTapsRequired: 1}));
		public const DOUBLE_TAP:GestouchControllerKey = new GestouchControllerKey("DOUBLE TAP", true, ObjectUtil.applyProperties(new TapGesture(), {numTapsRequired: 2}));
		
		private var _target:Object;
		private var _keys:Vector.<GestouchControllerKey> = new Vector.<GestouchControllerKey>();
		
		public function GestouchController(target:Object) 
		{
			super("Gestouch");
			_target = target;
		}
		
		public function addKey(key:GestouchControllerKey):GestouchControllerKey
		{
			key.gesture.target = _target;
			key.gesture.addEventListener(GestureEvent.GESTURE_STATE_CHANGE, handleGestureStateChange);
			_keys.push(key);
			return key;
		}
		
		public function removeKey(key:GestouchControllerKey):void
		{
			key.gesture.removeEventListener(GestureEvent.GESTURE_STATE_CHANGE, handleGestureStateChange);
			_keys.splice(_keys.indexOf(key), 1);
		}
		
		private function handleGestureStateChange(e:GestureEvent):void 
		{
			if (!enabled)
				return;
			/*
			var gesture:Gesture = e.currentTarget as Gesture;
			if (gesture.target !== _target)
				return;
			trace(e.newState.toString(), gesture.target);
			*/
			if (e.newState == GestureState.BEGAN || e.newState == GestureState.RECOGNIZED)
			{
				onKeyDown(GestouchControllerKey.fromGesture(e.currentTarget as Gesture));
			}
			else if (e.newState == GestureState.ENDED)
			{
				onKeyUp(GestouchControllerKey.fromGesture(e.currentTarget as Gesture));
			}
			//else if (e.newState == GestureState.RECOGNIZED)
			//{
				// Dispatch event, but no status change
				//keyDownEvent.dispatch(GestouchControllerKey.fromGesture(e.currentTarget as Gesture), 1);
			//}
		}
		
		override public function reset():void 
		{
			super.reset();
			for each(var key:GestouchControllerKey in _keys)
			{
				key.gesture.reset();
			}
		}
	}

}