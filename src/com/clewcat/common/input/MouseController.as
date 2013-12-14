package com.clewcat.common.input 
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicolas Tian
	 */
	public class MouseController extends Controller 
	{
		private var _target:DisplayObject;
		private var _lastMousePos:Point;
		private var _mouseDelta:Point = new Point();
		private var _mouseButtonDown:Boolean = false;
		
		public function MouseController(target:DisplayObject) 
		{
			super("Mouse");
			_target = target;
			_target.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseEvent);
			_target.addEventListener(MouseEvent.MOUSE_UP, handleMouseEvent);
		}
		
		private function handleMouseEvent(e:MouseEvent):void 
		{
			if (!enabled)
				return;
			_mouseButtonDown = e.buttonDown;
			if (_mouseButtonDown)
			{
				onKeyDown(MouseControllerKey.LEFT_BUTTON);
			}
			else
			{
				onKeyUp(MouseControllerKey.LEFT_BUTTON);
				/*
				// Dispatches drag canceled events.
				if (_mouseDelta.x != 0)
				{
					onKeyUp(MouseControllerKey.fromX(_mouseDelta.x, true));
				}
				if (_mouseDelta.y != 0)
				{
					onKeyUp(MouseControllerKey.fromY(_mouseDelta.y, true));
				}
				*/
			}
		}
		
		override public function update(deltaSecond:Number):void 
		{
			super.update(deltaSecond);
			
			if (!enabled)
				return;
				
			if (_lastMousePos == null)
			{
				_lastMousePos = new Point();
			}
			else
			{
				var dx:Number = _target.mouseX - _lastMousePos.x;
				var dy:Number = _target.mouseY - _lastMousePos.y;
				//trace(dx, dy, mouseButtonDown);
				_mouseDelta.x = dx;	
				_mouseDelta.y = dy;
				
				/*
				if (dx == 0 && _mouseDelta.x != 0)
				{
					onKeyUp(MouseControllerKey.fromX(_mouseDelta.x, _mouseButtonDown));
				}
				
				if (dy == 0 && _mouseDelta.y != 0)
				{
					onKeyUp(MouseControllerKey.fromY(_mouseDelta.y, _mouseButtonDown));
				}
				*/
				
				if (dx != 0)
				{
					onKeyDown(MouseControllerKey.fromX(dx, _mouseButtonDown),
						Math.abs(dx) * deltaSecond);
				}
				if (dy != 0)
				{
					onKeyDown(MouseControllerKey.fromY(dy, _mouseButtonDown),
						Math.abs(dy) * deltaSecond);
				}
			}
			_lastMousePos.x = _target.mouseX;
			_lastMousePos.y = _target.mouseY;

		}
		
		override public function reset():void 
		{
			super.reset();
			_mouseButtonDown = false;
			_lastMousePos.setTo(0, 0);
			_mouseDelta.setTo(0, 0);
		}
	}

}