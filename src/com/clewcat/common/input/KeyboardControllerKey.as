package com.clewcat.common.input 
{
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import me.sangtian.common.util.ObjectUtil;
	/**
	 * ...
	 * @author Nicolas Tian
	 */
	public class KeyboardControllerKey extends ControllerKey 
	{
		private var _keyCode:uint;
		
		public function get keyCode():uint 
		{
			return _keyCode;
		}
		
		public function KeyboardControllerKey(name:String, keyCode:uint) 
		{
			super(name);
			_keyCode = keyCode;
			
			_keyCodeMapping[keyCode] = this;
			/*
			CONFIG::debug
			{
				ASSERT(_nameMapping[name] == null, "ControllerKey with the same name already exists: " + name);
			}
			_nameMapping[name] = this;
			*/
		}
		
		private static var _keyCodeNameMapping:Object = ObjectUtil.constantsToObject(Keyboard, true);
		private static var _keyCodeMapping:Dictionary = new Dictionary();
		//private static var _nameMapping:Dictionary = new Dictionary();

		[Inline]
		public static function fromKeyCode(keyCode:uint):KeyboardControllerKey
		{
			var key:KeyboardControllerKey = _keyCodeMapping[keyCode];
			if (key == null)
			{
				key = new KeyboardControllerKey(_keyCodeNameMapping[keyCode], keyCode);
			}
			return key;
		}
		

		[Inline]
		public static function fromName(name:String):KeyboardControllerKey
		{
			CONFIG::debug
			{
				ASSERT(Keyboard[name] is uint, "Can't find keyboard key by name: " + name);
			}
			return fromKeyCode(Keyboard[name]);
		}
		
		public static function fromNames(names:Array):Vector.<ControllerKey>
		{
			var keys:Vector.<ControllerKey> = new Vector.<ControllerKey>();
			for each(var name:String in names)
			{
				keys.push(fromName(name));
			}
			return keys;
		}

		/**
		 * 
		 * @param	name Must be constant in Keyboard class
		 * @return 
		 * @error Error If the constant name doesn't exist in Keyboard class.
		[Inline]
		public static function fromName(name:String):KeyboardControllerKey
		{
			return ControllerKey.fromName(name) as KeyboardControllerKey;//fromKeyCode(Keyboard[name]);
		}
		
		private static var _cached:Boolean = false;
		public static function cacheKeyboardKeys():void
		{
			if (_cached)
				return;
			for each(var name:String in ObjectUtil.getConstantNames(Keyboard))
			{
				new KeyboardControllerKey(name, Keyboard[name]);
			}
			_cached = true;
		}
		 */
	}

}