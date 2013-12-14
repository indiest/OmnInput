package com.clewcat.common.input 
{
	import flash.utils.Dictionary;
	import me.sangtian.common.util.MathUtil;
	/**
	 * ...
	 * @author Nicolas Tian
	 */
	public class InputAxis implements IComboMove
	{
		public static const AXIS_ID_X:String = "X";
		public static const AXIS_ID_Y:String = "Y";
		
		private var _id:String;
		private var _positiveKeys:Vector.<ControllerKey>;
		private var _negativeKeys:Vector.<ControllerKey>;
		private var _gravity:Number;
		private var _sensitivity:Number;
		private var _value:Number;
		private var _dead:Number;
		
		private var _enabled:Boolean = true;
		private var _keyPressureMapping:Dictionary = new Dictionary();
		
		public function get id():String 
		{
			return _id;
		}
		
		public function get positiveKeys():Vector.<ControllerKey> 
		{
			return _positiveKeys;
		}
		
		public function get negativeKeys():Vector.<ControllerKey> 
		{
			return _negativeKeys;
		}
		
		public function get gravity():Number 
		{
			return _gravity;
		}
		
		public function set gravity(value:Number):void 
		{
			_gravity = value;
		}
		
		public function get sensitivity():Number 
		{
			return _sensitivity;
		}
		
		public function set sensitivity(value:Number):void 
		{
			_sensitivity = value;
		}
		
		public function get value():Number 
		{
			return _value;
		}
		
		public function set value(value:Number):void 
		{
			_value = MathUtil.clamp(value, -1, 1);
		}
		
		public function get dead():Number 
		{
			return _dead;
		}
		
		public function set dead(value:Number):void 
		{
			_dead = value;
		}
		
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
		}
		
		public function InputAxis(id:String, negativeKeys:Vector.<ControllerKey>, positiveKeys:Vector.<ControllerKey>, gravity:Number = 3, sensitivity:Number = 3)
		{
			_id = id;
			_negativeKeys = negativeKeys;
			_positiveKeys = positiveKeys;
			_gravity = gravity;
			_sensitivity = sensitivity;
			_value = 0;
			_dead = gravity / 60;
			reset();
		}
		
		public function update(deltaSecond:Number):void
		{
			if (!enabled)
				return;
				
			for (var key:* in _keyPressureMapping)
			{
				value += _keyPressureMapping[key] * sensitivity;
			}
			
			if (value != 0)
			{
				value -= MathUtil.sign(value) * gravity * deltaSecond;
				//trace(value);
				if (Math.abs(value) < dead)
				{
					value = 0;
				}
			}
		}
		
		public function push(key:ControllerKey, pressure:Number):void
		{
			if (!enabled)
				return;
				
			if (_keyPressureMapping[key] is Number)
			{
				_keyPressureMapping[key] = pressure;
			}
		}
		
		public function release(key:ControllerKey):void
		{
			if (!enabled)
				return;
				
			if (_keyPressureMapping[key] is Number)
			{
				_keyPressureMapping[key] = 0;
			}
		}
		
		public function reset():void
		{
			_value = 0;
			var key:ControllerKey;
			for each(key in _positiveKeys)
				_keyPressureMapping[key] = 0;
			for each(key in _negativeKeys)
				_keyPressureMapping[key] = 0;
		}
		
		/* INTERFACE com.clewcat.common.input.IComboMove */
		
		public function checkMove():Boolean 
		{
			return value != 0;
		}
	}

}