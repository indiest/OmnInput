package com.clewcat.common.input 
{
	import flash.utils.Dictionary;
	import me.sangtian.common.ProcedureProfiler;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Nicolas Tian
	 */
	public class InputManager 
	{
		private var _controllers:Vector.<Controller> = new Vector.<Controller>();
		private var _actions:Dictionary = new Dictionary();
		private var _axes:Dictionary = new Dictionary();
		private var _combos:Dictionary = new Dictionary();
		private var _enabled:Boolean = true;
		private var _actionEvent:Signal = new Signal(InputAction);
		
		public function get numControllers():uint
		{
			return _controllers.length;
		}
		
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
		}
		
		public function get actionEvent():Signal 
		{
			return _actionEvent;
		}
		
		public function InputManager() 
		{
			
		}
		
		public function addController(controller:Controller):InputManager
		{
			_controllers.push(controller);
			controller.keyDownEvent.add(handleControllerKeyDown);
			controller.keyUpEvent.add(handleControllerKeyUp);
			return this;
		}
		
		private function handleControllerKeyUp(key:ControllerKey):void 
		{
			for each(var action:InputAction in _actions)
			{
				if (action.keys.indexOf(key) >= 0)
				{
					action.unhold();
				}
			}
			
			for each(var axis:InputAxis in _axes)
			{
				axis.release(key);
			}
		}
		
		private function handleControllerKeyDown(key:ControllerKey, pressure:Number):void 
		{
			for each(var action:InputAction in _actions)
			{
				if (key.existsIn(action.keys))
				{
					action.hold(pressure);
				}
			}
			
			for each(var axis:InputAxis in _axes)
			{
				if (key.existsIn(axis.positiveKeys))
				{
					//axis.value += pressure;
					//trace(key, pressure, axis.id, axis.value);
					axis.push(key, pressure);
				}
				else if (key.existsIn(axis.negativeKeys))
				{
					//axis.value -= pressure;
					axis.push(key, -pressure);
				}
			}
		}
		
		public function getController(index:uint):Controller
		{
			return _controllers[index];
		}
		
		public function getControllerByName(name:String):Controller
		{
			for each(var contrller:Controller in _controllers)
			{
				if (contrller.name == name)
					return contrller;
			}
			return null;
		}
		
		public function getControllerByType(type:Class):Controller
		{
			for each(var contrller:Controller in _controllers)
			{
				if (contrller is type)
					return contrller;
			}
			return null;
		}
		
		public function addAction(action:InputAction):InputManager
		{
			_actions[action.id] = action;
			action.activateEvent.add(dispatchActionEvent);
			return this;
		}
		
		private function dispatchActionEvent(action:InputAction):void 
		{
			if (!enabled)
				return;
			_actionEvent.dispatch(action);
		}
		
		public function getAction(actionId:String):InputAction
		{
			return _actions[actionId];
		}
		
		public function isActionActive(actionId:String):Boolean
		{
			if (!enabled)
				return false;
				
			var action:InputAction = _actions[actionId];
			if (action == null)
			{
				CONFIG::debug
				{
					ASSERT(false, "Can't find action by id: " + actionId);
				}
				return false;
			}
			return action.active;
		}
		
		public function addAxis(axis:InputAxis):InputManager
		{
			_axes[axis.id] = axis;
			return this;
		}
		
		public function getAxis(axisId:String):InputAxis
		{
			return _axes[axisId];
		}
		
		public function getAxisValue(axisId:String):Number
		{
			if (!enabled)
				return 0;
				
			var axis:InputAxis = _axes[axisId];
			if (axis == null)
			{
				CONFIG::debug
				{
					ASSERT(false, "Can't find axis by id: " + axisId);
				}
				return 0;
			}
			return axis.value;
		}
		
		public function addCombo(combo:InputCombo):InputManager
		{
			_combos[combo.id] = combo;
			// Add actions and axis that are not existed yet.
			for each(var move:IComboMove in combo.moves)
			{
				if (move is InputAction)
				{
					var action:InputAction = move as InputAction;
					if (getAction(action.id) == null)
						addAction(action);
				}
				else if (move is InputAxis)
				{
					var axis:InputAxis = move as InputAxis;
					if (getAxis(axis.id) == null)
						addAxis(axis);
				}
			}
			return this;
		}
		
		public function getCombo(comboId:String):InputCombo
		{
			return _combos[comboId];
		}
		
		public function isComboActive(comboId:String):Boolean
		{
			if (!enabled)
				return false;
				
			var combo:InputCombo = _combos[comboId];
			if (combo == null)
			{
				CONFIG::debug
				{
					ASSERT(false, "Can't find combo by id: " + comboId);
				}
				return false;
			}
			return combo.active;
		}
		
		CONFIG::debug
		{
		private var _profiler:ProcedureProfiler = new ProcedureProfiler();
		}
		
		public function update(deltaSecond:Number):void
		{
			if (!enabled)
				return;
				
			CONFIG::debug
			{
				_profiler.startTiming();
			}
				
			for each(var controller:Controller in _controllers)
			{
				controller.update(deltaSecond);
			}
			
			for each(var action:InputAction in _actions)
			{
				action.update(deltaSecond);
			}
			
			for each(var axis:InputAxis in _axes)
			{
				axis.update(deltaSecond);
			}
			
			for each(var combo:InputCombo in _combos)
			{
				combo.update(deltaSecond);
			}
			
			CONFIG::debug
			{
				_profiler.countTimes();
				var ms:Number = _profiler.getAverageMillisecond();
				if (ms > 1)
					trace("[Input] Update average time:", ms);
			}
		}
		
		public function resetAll():void
		{
			for each(var controller:Controller in _controllers)
			{
				controller.reset();
			}
			
			for each(var action:InputAction in _actions)
			{
				action.reset();
			}
			
			for each(var axis:InputAxis in _axes)
			{
				axis.reset();
			}
			
			for each(var combo:InputCombo in _combos)
			{
				combo.reset();
			}
		}
	}

}