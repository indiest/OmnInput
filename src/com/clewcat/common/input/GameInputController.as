package com.clewcat.common.input 
{
	import flash.events.Event;
	import flash.events.GameInputEvent;
	import flash.ui.GameInput;
	import flash.ui.GameInputControl;
	import flash.ui.GameInputDevice;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Nicolas Tian
	 */
	public class GameInputController extends Controller 
	{
		public static const MAX_NUM_DEVICE:uint = 4;
		public static const DEVICE_INDEX_ALL:uint = (1 << MAX_NUM_DEVICE) - 1;
		private var _deviceIndexMask:uint;
		private var _device:GameInputDevice;
		private var _input:GameInput;
		
		private static var _deviceToControllerMapping:Dictionary = new Dictionary(false);
		
		public function GameInputController(deviceIndexMask:uint = DEVICE_INDEX_ALL) 
		{
			ASSERT(isSupported, "GameInput is not supported");
			_deviceIndexMask = deviceIndexMask;
			for (var i:int = 0; i < GameInput.numDevices; i++)
			{
				if ((_deviceIndexMask & (1 << i)) != 0)
				{
					addDevice(GameInput.getDeviceAt(i));
				}
			}
			super("Xbox/OUYA Controller");
			_input = new GameInput();
			_input.addEventListener(GameInputEvent.DEVICE_ADDED, handleDeviceAdded);
			_input.addEventListener(GameInputEvent.DEVICE_REMOVED, handleDeviceRemoved);
		}
		
		private function getDeviceIndex(device:GameInputDevice):int
		{
			for (var i:int = 0; i < GameInput.numDevices; i++)
			{
				if (GameInput.getDeviceAt(i) === device)
					return i;
			}
			return -1;
		}
		
		private function isListeningDevice(device:GameInputDevice):Boolean
		{
			var index:int = getDeviceIndex(device);
			if (index < 0)
				return false;
			return (_deviceIndexMask & (1 << index)) != 0;
		}
		
		private function addDevice(device:GameInputDevice):void 
		{
			_deviceToControllerMapping[device] = this;
			for (var i:int = 0; i < device.numControls; i++)
			{
				device.getControlAt(i).addEventListener(Event.CHANGE, handleControlChange);
			}
		}
		
		private function removeDevice(device:GameInputDevice):void 
		{
			for (var i:int = 0; i < device.numControls; i++)
			{
				device.getControlAt(i).removeEventListener(Event.CHANGE, handleControlChange);
			}
			delete _deviceToControllerMapping[device];
		}
		
		private function handleControlChange(e:Event):void 
		{
			var control:GameInputControl = e.currentTarget as GameInputControl;
			trace(control.toString(), control.value);
		}
		
		private function handleDeviceRemoved(e:GameInputEvent):void 
		{
			trace("Device removed:", e.device.id, e.device.name);
			if (isListeningDevice(e.device))
				removeDevice(e.device);
		}
		
		private function handleDeviceAdded(e:GameInputEvent):void 
		{
			trace("Device added:", e.device.id, e.device.name);
			if (isListeningDevice(e.device))
				addDevice(e.device);
		}
		
		public static function isSupported():Boolean
		{
			return GameInput.isSupported;
		}
	}

}