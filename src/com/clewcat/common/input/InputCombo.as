package com.clewcat.common.input 
{
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Nicolas Tian
	 */
	public class InputCombo 
	{
		private var _id:String;
		private var _moves:Vector.<IComboMove>;
		private var _timeout:Number;
		
		private var _enabled:Boolean = true;
		private var _phase:uint;
		private var _timeoutTime:Number;
		private var _active:Boolean;
		private var _activateEvent:Signal = new Signal(InputCombo);
		
		public function get id():String 
		{
			return _id;
		}
		
		public function get moves():Vector.<IComboMove> 
		{
			return _moves;
		}
		
		public function get timeout():Number 
		{
			return _timeout;
		}
		
		public function set timeout(value:Number):void 
		{
			_timeout = value;
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
		
		public function InputCombo(id:String, moves:Vector.<IComboMove>, timeout:Number = 0.5) 
		{
			_id = id;
			_moves = moves;
			_timeout = timeout;
			reset();
		}
		
		public function update(deltaSecond:Number):void
		{
			if (!enabled)
				return;
				
			if (_phase == _moves.length)
			{
				reset();
			}
			
			//trace("Combo phase", _phase, _moves[_phase].checkMove());
			if (_moves[_phase].checkMove())
			{
				_phase++;
				_timeoutTime = 0;
				if (_phase == _moves.length)
				{
					_active = true;
					_activateEvent.dispatch(this);
				}
			}
			else
			{
				_timeoutTime += deltaSecond;
				if (_timeoutTime > _timeout)
				{
					reset();
				}
			}
		}
		
		public function reset():void
		{
			_phase = 0;
			_timeoutTime = 0;
			_active = false;
		}
	}

}