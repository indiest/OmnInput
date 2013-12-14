package com.clewcat.common.input 
{
	import me.sangtian.common.Time;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Nicolas Tian
	 */
	public class InputAction implements IComboMove
	{
		public static const ACTION_ID_JUMP:String = "Jump";
		public static const ACTION_ID_ATTACK:String = "Attack";
		
		private var _id:String;
		private var _keys:Vector.<ControllerKey>;
		private var _minHoldTime:Number;
		private var _cooldownTime:Number;
		private var _activateOnUnhold:Boolean;
		
		private var _enabled:Boolean = true;
		private var _active:Boolean = false;
		private var _isHolding:Boolean;
		private var _holdTime:Number = 0;
		private var _cooldownRemainingTime:Number = 0;
		private var _activateEvent:Signal = new Signal(InputAction);
		// Whether the activation should be checked when keys are unholding, rather than holding.
		// Set this to true if there are recognizable gestouch key
		private var _justUnholded:Boolean = false;
		
		public function get id():String 
		{
			return _id;
		}
		
		public function get keys():Vector.<ControllerKey> 
		{
			return _keys;
		}
		
		public function get minHoldTime():Number 
		{
			return _minHoldTime;
		}
		
		public function set minHoldTime(value:Number):void 
		{
			_minHoldTime = value;
		}
		
		public function get cooldownTime():Number 
		{
			return _cooldownTime;
		}
		
		public function set cooldownTime(value:Number):void 
		{
			_cooldownTime = value;
		}
		
		public function get activateOnUnhold():Boolean 
		{
			return _activateOnUnhold;
		}
		
		public function set activateOnUnhold(value:Boolean):void 
		{
			_activateOnUnhold = value;
		}
		
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
		}
		
		public function get active():Boolean 
		{
			return _active;
		}
		
		public function get activateEvent():Signal 
		{
			return _activateEvent;
		}
		
		public function get isHolding():Boolean 
		{
			return _isHolding;
		}
		
		public function InputAction(id:String, keys:Vector.<ControllerKey>, minHoldTime:Number = 0, cooldownTime:Number = 0, activateOnUnhold:Boolean = false) 
		{
			_id = id;
			_keys = keys;
			_minHoldTime = minHoldTime;
			_cooldownTime = cooldownTime;
			_activateOnUnhold = activateOnUnhold;
		}
		
		public function update(deltaSecond:Number):void
		{
			if (!enabled)
				return;
				
			_cooldownRemainingTime -= deltaSecond;
			if (_cooldownRemainingTime <= 0 && _isHolding)
			{
				_holdTime += deltaSecond;
				if (!_activateOnUnhold)
					checkActivation();
			}
			else
			{
				if (_justUnholded && _activateOnUnhold && _cooldownRemainingTime <= 0)
				{
					checkActivation();
				}
				else
				{
					_active = false;
				}
				_holdTime = 0;
			}
			_justUnholded = false;
		}
		
		private function checkActivation():void 
		{
			if (_holdTime >= _minHoldTime)
			{
				if (_active == false)
				{
					_cooldownRemainingTime = _cooldownTime;
					_active = true;
					_activateEvent.dispatch(this);
					//trace("Activate action:", id);
				}
			}
		}
		
		public function hold(pressure:Number = 1):void 
		{
			if (!enabled)
				return;
				
			_isHolding = true;
			//trace("Hold action:", id);
		}
		
		public function unhold():void
		{
			if (!enabled)
				return;
				
			_isHolding = false;
			_justUnholded = true;
			//trace("Unhold action:", id);
		}
		
		public function reset():void
		{
			unhold();
			_active = false;
			_cooldownRemainingTime = 0;
		}
		
		/* INTERFACE com.clewcat.common.input.IComboMove */
		
		public function checkMove():Boolean 
		{
			return active;
		}
	}

}