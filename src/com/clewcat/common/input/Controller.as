package com.clewcat.common.input 
{
	import flash.utils.Dictionary;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Nicolas Tian
	 */
	public class Controller 
	{
		private static const KEY_STATUS_PRESSING:int = 1;
		private static const KEY_STATUS_RELEASING:int = 0;
		private static const KEY_STATUS_RELEASED:int = -1;
		private var _keyStatusMapping:Dictionary = new Dictionary();
		
		private var _name:String;
		private var _enabled:Boolean = true;
		private var _keyDownEvent:Signal = new Signal(ControllerKey, Number);
		private var _keyUpEvent:Signal = new Signal(ControllerKey);
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
		}
		
		public function get keyDownEvent():Signal 
		{
			return _keyDownEvent;
		}
		
		public function get keyUpEvent():Signal 
		{
			return _keyUpEvent;
		}
		
		public function Controller(name:String) 
		{
			_name = name;
		}
		
		public function update(deltaSecond:Number):void
		{
			if (!enabled)
				return;
			for (var key:ControllerKey in _keyStatusMapping)
			{
				var status:Number = _keyStatusMapping[key];
				if (status > KEY_STATUS_RELEASING)//== KEY_STATUS_PRESSING)
				{
					//keyDownEvent.dispatch(key, status);
					if (key.autoRelease)
					{
						_keyStatusMapping[key] = KEY_STATUS_RELEASING;
					}
				}
				else if (status == KEY_STATUS_RELEASING)
				{
					keyUpEvent.dispatch(key);
					_keyStatusMapping[key] = KEY_STATUS_RELEASED;
				}
				else if (status == KEY_STATUS_RELEASED)
				{
					delete _keyStatusMapping[key];
				}
			}
		}
		
		public function reset():void
		{
			for (var key:ControllerKey in _keyStatusMapping)
			{
				delete _keyStatusMapping[key];
			}
		}

		protected function onKeyDown(key:ControllerKey, pressure:Number = 1):void
		{
			_keyStatusMapping[key] = pressure;//KEY_STATUS_PRESSING;
			keyDownEvent.dispatch(key, pressure);
		}
		
		protected function onKeyUp(key:ControllerKey):void
		{
			_keyStatusMapping[key] = KEY_STATUS_RELEASING;
			//keyUpEvent.dispatch(key);
		}
		
		public function isKeyDown(key:ControllerKey):Boolean
		{
			if (!enabled)
				return false;
			return (_keyStatusMapping[key] > KEY_STATUS_RELEASING);
		}
		
		public function isKeyUp(key:ControllerKey):Boolean
		{
			if (!enabled)
				return false;
			return (_keyStatusMapping[key] <= KEY_STATUS_RELEASING);
		}
		
		// TODO: Recording
		//public function startRecording(duration:Number = 0, buffer:Vector.<InputRecord> = null):void;
		//public function stopRecording():Vector.<InputRecord>;
	}

}