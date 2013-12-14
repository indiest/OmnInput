package 
{
	import flash.utils.describeType;
	import com.clewcat.common.input.InputAction;
	import com.clewcat.common.input.KeyboardController;
	import com.clewcat.common.input.MouseController;
	import com.clewcat.common.input.OmnInput;
	/**
	 * ...
	 * @author Nicolas Tian
	 */
	public class OmnInputTest extends TestBase 
	{
		[Embed(source = "config1.json", mimeType = "application/octet-stream")]
		private static const CONFIG:Class;
		
		public function OmnInputTest() 
		{
			OmnInput.registerController(new KeyboardController(stage));
			OmnInput.registerController(new MouseController(stage));
			OmnInput.loadConfig(new CONFIG());
		}
		
		override public function update(deltaSecond:Number):void 
		{
			OmnInput.update(deltaSecond);
		}
	}

}