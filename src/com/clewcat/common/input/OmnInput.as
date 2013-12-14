package com.clewcat.common.input 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Nicolas Tian
	 */
	public class OmnInput 
	{
		
		private static var _controllerMapping:Dictionary = new Dictionary();
		private static var _managers:Vector.<InputManager> = new Vector.<InputManager>();
		
		public static function registerController(controller:Controller):void
		{
			_controllerMapping[controller.name] = controller;
		}
		
		public static function getManager(index:uint = 0):InputManager
		{
			return _managers[index];
		}
		
		public static function isJumping(index:uint = 0):Boolean
		{
			return getManager(index).isActionActive(InputAction.ACTION_ID_JUMP);
		}
		
		public static function isShooting(index:uint = 0):Boolean
		{
			return getManager(index).isActionActive(InputAction.ACTION_ID_ATTACK);
		}
		
		public static function getAxisX(index:uint = 0):Number
		{
			return getManager(index).getAxisValue(InputAxis.AXIS_ID_X);
		}
		
		public static function getAxisY(index:uint = 0):Number
		{
			return getManager(index).getAxisValue(InputAxis.AXIS_ID_Y);
		}
		
		public static function update(deltaSecond:Number):void
		{
			for each(var manager:InputManager in _managers)
			{
				manager.update(deltaSecond);
			}
		}
		
		public static function loadConfig(cfg:String):void
		{
			var cfgObj:Object = JSON.parse(cfg);
			for each (var managerObj:Object in cfgObj.managers)
			{
				var manager:InputManager = new InputManager();
				for each (var controllerName:String in managerObj.controllers)
				{
					var controller:Controller = _controllerMapping[controllerName];
					CONFIG::debug
					{
						ASSERT(controller != null, "Can't find controller by name: " + controllerName);
					}
					manager.addController(controller);
				}
				for each (var actionObj:Object in managerObj.actions)
				{
					var action:InputAction = new InputAction(actionObj.id,
						ControllerKey.fromNames(actionObj.keys),
						actionObj.minHoldTime, actionObj.cooldownTime,
						actionObj.activateOnUnhold);
					manager.addAction(action);
				}
				for each (var axisObj:Object in managerObj.axes)
				{
					var negativeKeys:* = axisObj.negativeKeys;
					var positiveKeys:* = axisObj.positiveKeys;
					var axis:InputAxis = new InputAxis(axisObj.id,
						negativeKeys is Array ? ControllerKey.fromNames(negativeKeys) : manager.getAction(negativeKeys).keys,
						positiveKeys is Array ? ControllerKey.fromNames(positiveKeys) : manager.getAction(positiveKeys).keys);
					if (axisObj.gravity is Number)
						axis.gravity = axisObj.gravity;
					if (axisObj.sensitivity is Number)
						axis.sensitivity = axisObj.sensitivity;
					manager.addAxis(axis);
				}
				for each (var comboObj:Object in managerObj.combos)
				{
					var moves:Vector.<IComboMove> = new Vector.<IComboMove>();
					for each(var moveName:String in comboObj.moves)
					{
						moves.push(manager.getAction(moveName) || manager.getAxis(moveName));
					}
					var combo:InputCombo = new InputCombo(comboObj.id, moves);
					if (comboObj.timeout is Number)
						combo.timeout = comboObj.timeout;
					manager.addCombo(combo);
				}
				_managers.push(manager);
			}
		}
	}

}