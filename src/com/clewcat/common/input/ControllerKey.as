package com.clewcat.common.input 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Nicolas Tian
	 */
	public class ControllerKey 
	{
		private var _name:String;
		private var _autoRelease:Boolean;
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get autoRelease():Boolean 
		{
			return _autoRelease;
		}
		
		public function ControllerKey(name:String, autoRelease:Boolean = false) 
		{
			_name = name;
			_autoRelease = autoRelease;
		}
		
		public function toString():String
		{
			return _name;
		}
		
		public function equals(otherKey:ControllerKey):Boolean
		{
			return this === otherKey;
		}
		
		public function existsIn(keys:Vector.<ControllerKey>):Boolean
		{
			for each(var key:ControllerKey in keys)
			{
				if (equals(key))
					return true;
			}
			return false;
		}
	}

}