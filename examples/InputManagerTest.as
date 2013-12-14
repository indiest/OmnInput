package 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import me.sangtian.common.Input;
	import com.clewcat.common.input.ControllerKey;
	import com.clewcat.common.input.IComboMove;
	import com.clewcat.common.input.InputAction;
	import com.clewcat.common.input.InputAxis;
	import com.clewcat.common.input.InputCombo;
	import com.clewcat.common.input.InputConfig;
	import com.clewcat.common.input.InputManager;
	import com.clewcat.common.input.KeyboardController;
	import com.clewcat.common.input.KeyboardControllerKey;
	import com.clewcat.common.input.MouseController;
	import com.clewcat.common.input.MouseControllerKey;
	import me.sangtian.common.util.MathUtil;
	
	/**
	 * ...
	 * @author Nicolas Tian
	 */
	[SWF(width=800, height=600, bgColor="#FFFFFF")]
	public class InputManagerTest extends TestBase 
	{
		private var _im:InputManager;
		private var _shape:Shape = new Shape();
		private var _velocity:Point = new Point();
		
		public function InputManagerTest() 
		{
			_im = new InputManager();
			_im.addController(new KeyboardController(stage))
				.addController(new MouseController(stage))
				.addAction(new InputAction("Left", Vector.<ControllerKey>([
					KeyboardControllerKey.fromName("LEFT"),
					KeyboardControllerKey.fromName("A"),
					MouseControllerKey.DRAG_LEFT
					])
				))
				.addAction(new InputAction("Right", Vector.<ControllerKey>([
					KeyboardControllerKey.fromName("RIGHT"),
					KeyboardControllerKey.fromName("D"),
					MouseControllerKey.DRAG_RIGHT
					])
				))
				.addAction(new InputAction("Up", Vector.<ControllerKey>([
					KeyboardControllerKey.fromName("UP"),
					KeyboardControllerKey.fromName("W"),
					MouseControllerKey.DRAG_UP
					])
				))
				.addAction(new InputAction("Down", Vector.<ControllerKey>([
					KeyboardControllerKey.fromName("DOWN"),
					KeyboardControllerKey.fromName("S"),
					MouseControllerKey.DRAG_DOWN
					])
				))
				.addAxis(new InputAxis(InputAxis.AXIS_ID_X, 
					_im.getAction("Left").keys,
					_im.getAction("Right").keys
				))
				.addAxis(new InputAxis(InputAxis.AXIS_ID_Y, 
					_im.getAction("Up").keys,
					_im.getAction("Down").keys
				))
				.addAction(new InputAction("Shoot", Vector.<ControllerKey>([
					KeyboardControllerKey.fromKeyCode(Keyboard.SPACE)]),
					0, 0.2
				))
				.addAction(new InputAction("Blast", Vector.<ControllerKey>([
					KeyboardControllerKey.fromKeyCode(Keyboard.SPACE)]),
					1.0, 3.0, true
				))
				.addCombo(new InputCombo("SuperShoot", Vector.<IComboMove>([
					_im.getAction("Left"),
					_im.getAction("Right"),
					_im.getAction("Shoot")])
				));
					
			_shape.graphics.beginFill(0xff00ff);
			_shape.graphics.drawCircle(0, 0, 50);
			_shape.graphics.endFill();
			_shape.x = stage.stageWidth >> 1;
			_shape.y = stage.stageHeight >> 1;
			addChild(_shape);
		}
		
		override public function update(deltaSecond:Number):void 
		{
			_im.update(deltaSecond);
			_velocity.x = 200 * _im.getAxisValue(InputAxis.AXIS_ID_X);
			_velocity.y = 200 * _im.getAxisValue(InputAxis.AXIS_ID_Y);
			_shape.x = MathUtil.clamp(_shape.x + _velocity.x * deltaSecond, 0, stage.stageWidth);
			_shape.y = MathUtil.clamp(_shape.y + _velocity.y * deltaSecond, 0, stage.stageHeight);
			
			if (_im.isComboActive("SuperShoot"))
			{
				trace("SuperShoot!");
			}
			else if (_im.isActionActive("Blast"))
			{
				trace("Blast");
			}
			else if (_im.isActionActive("Shoot"))
			{
				trace("Shoot");
			}
			
		}
	}

}