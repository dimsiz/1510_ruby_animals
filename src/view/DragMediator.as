/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 04.10.13
 * Time: 13:46
 * To change this template use File | Settings | File Templates.
 */
package view
{
	import com.greensock.TweenLite;

	import controller.ICommand;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import model.Utils;

	public class DragMediator
	{
		private var _dragee:Sprite;
		private var _coordsOrigin:Sprite;
		private var _offSet:PointDescription;
		private var _minX:int;
		private var _minY:int;
		private var _maxX:int;
		private var _maxY:int;
		private var _listener:ICommand;

		public function DragMediator(sprite:Sprite, minX:int, minY:int, maxX:int, maxY:int)
		{
			_dragee = sprite;
			_minX = minX;
			_minY = minY;
			_maxX = maxX;
			_maxY = maxY;
			_coordsOrigin = _dragee.parent as Sprite;
			_offSet = new PointDescription();
		}

		public function pushButton(buttonView:Object):void
		{
			this.unlockMouse(buttonView.hitarea);
			buttonView.hitarea.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			buttonView.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		private function unlockMouse(hitArea:Sprite):void
		{
			if(!hitArea.mouseEnabled)
			{
				if(MainFlyAni.RELEASE_MODE) hitArea.alpha = 0;
				hitArea.visible = true;
				hitArea.mouseEnabled = true;
				hitArea.mouseChildren = true;
			}
		}

		public function addDragListener(command:ICommand):void
		{
			if(_listener)
			{
				throw new Error();
			}
			else
			{
				_listener = command;
			}
		}

		public function goFront():void
		{
			this.startMove();
			TweenLite.to(_dragee, 1, {x: _maxX, y: _maxY, onComplete: stopMove});
		}

		public function goBack():void
		{
			this.startMove();
			TweenLite.to(_dragee, 1, {x: _minX, y: _minY, onComplete: stopMove});
		}

		public function go(x:int, y:int):void
		{
			x = Utils.inBounds(_minX, _maxX, -x);
			y = Utils.inBounds(_minY, _maxY, -y);
			this.startMove();
			TweenLite.to(_dragee, 1, {x: x, y: y, onComplete: stopMove});
		}

		private function onMouseDown(event:MouseEvent):void
		{
			_offSet.x = _coordsOrigin.mouseX - _dragee.x;
			_offSet.y = _coordsOrigin.mouseY - _dragee.y;

			EnterFrameBroadcaster.instance.addEventListener(Event.ENTER_FRAME, onFrame);
		}

		private function onFrame(event:Event):void
		{
			_dragee.x = Utils.inBounds(_minX, _maxX, _coordsOrigin.mouseX - _offSet.x);
			_dragee.y = Utils.inBounds(_minY, _maxY, _coordsOrigin.mouseY - _offSet.y);
			this.dispatchDrag();
		}

		private function onMouseUp(event:MouseEvent):void
		{
			this.dispatchDrag();
			EnterFrameBroadcaster.instance.removeEventListener(Event.ENTER_FRAME, onFrame);
		}

		private function dispatchDrag():void
		{
			if(_listener)
			{
				_listener.execute(_dragee);
			}
		}

		private function startMove():void
		{
			EnterFrameBroadcaster.instance.addEventListener(Event.ENTER_FRAME, onMove);
		}

		private function stopMove():void
		{
			this.dispatchDrag();
			EnterFrameBroadcaster.instance.removeEventListener(Event.ENTER_FRAME, onMove);
		}

		private function onMove(event:Event):void
		{
			this.dispatchDrag();
		}
	}
}
