package view
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.luaye.console.C;

	import controller.ICommand;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import model.Utils;

	public class FlyButtonMediator extends EventDispatcher
	{
		private static const APPEAR_SPEED:Number = 0.2;
		private static const MOVE_SPEED:Number = 0.2;
		private static const ROTATE_SPEED:Number = 1;
		private static const CLICK_RADIUS:int = 20;
		
		private var _asset:Sprite;
		private var _rotator:Sprite;
		private var _onClick:ICommand;
		private var _hitArea:Sprite;
		private var _shakeX:int;
		private var _shakeY:int;
		private var _shakeSpeed:Number;
		private var _data:Object;
		private var _coordsCached:PointDescription;
		private var _mouseCoords:Point;
		private var _mouseTempCoords:Point;

		public function FlyButtonMediator(asset:Sprite, data:Object = null)
		{
			_mouseCoords = new Point();
			_mouseTempCoords = new Point();
			_asset = asset;
			_data = data;
			_rotator = _asset['rotator'];
			if(_rotator)
			{
				this.startNewRotation();
			}
			_hitArea = _asset['hitarea'] as Sprite;
			if(_hitArea)
			{
				_hitArea.visible = false;
			}
		}
		
		public function get data():Object
		{
			return _data;
		}

		public function addXshake(magnitude:int, speed:Number):void
		{
			_shakeX = magnitude;
			_shakeSpeed = speed;
			TweenLite.to(_asset, _shakeSpeed / 2, {x: _asset.x + magnitude / 2, onComplete: goBack});
		}
		
		public function addYshake(magnitude:int, speed:Number):void
		{
			_shakeY = magnitude;
			_shakeSpeed = speed;
			TweenLite.to(_asset, _shakeSpeed / 2, {y: _asset.y + magnitude / 2, onComplete: goBack});
		}
		
		public function appear():void
		{
			_asset.alpha = 1;
			TweenLite.from(_asset, APPEAR_SPEED, {alpha: 0, ease:Linear.easeNone, onComplete: animationComplete});
		}
		
		public function disappear():void
		{
			TweenLite.to(_asset, APPEAR_SPEED, {alpha: 0, ease:Linear.easeNone, onComplete: animationComplete});
		}
		
		public function moveFrom(x:int, y:int, scale:Number = 1):void
		{
			var targetX:int = _asset.x + x;
			var targetY:int = _asset.y + y;
			TweenLite.from(_asset, MOVE_SPEED, {x: targetX, y:targetY, scaleX: scale, scaleY: scale, ease:Linear.easeNone, onComplete: animationComplete});
		}
		
		public function moveTo(x:int, y:int, scale:Number = 1):void
		{
			var targetX:int = _asset.x + x;
			var targetY:int = _asset.y + y;
			_coordsCached = new PointDescription(_asset.x, _asset.y, _asset.scaleX);
			TweenLite.to(_asset, MOVE_SPEED, {x: targetX, y:targetY, scaleX: scale, scaleY: scale, ease:Linear.easeNone, onComplete: animationComplete});
		}
		
		public function destroy():void
		{
			TweenLite.killTweensOf(_rotator);
			TweenLite.killTweensOf(_asset);
			if(_onClick)
			{
				_hitArea.removeEventListener(MouseEvent.CLICK, onClick);
				_onClick = null;
			}
		}

		public function get appearsOnScreen():Boolean
		{
			return _asset.alpha == 1;
		}
		
		public function addClickListener(command:ICommand):void
		{
			if(_onClick) throw new Error();
			this.unlockMouse();
			_onClick = command;
			_hitArea.addEventListener(MouseEvent.CLICK, onClick);
			_hitArea.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		private function unlockMouse():void
		{
			if(MainFlyAni.RELEASE_MODE) _hitArea.alpha = 0;
			_hitArea.visible = true;
			_hitArea.mouseEnabled = true;
			_hitArea.mouseChildren = true;
		}
		
		private function onClick(event:MouseEvent):void
		{
			_mouseTempCoords.x = event.stageX;
			_mouseTempCoords.y = event.stageY;
			if(Utils.areNear(_mouseTempCoords, _mouseCoords, CLICK_RADIUS))
			{
				_onClick.execute(_data);
			}
		}

		private function onMouseDown(event:MouseEvent):void
		{
			_mouseCoords.x = event.stageX;
			_mouseCoords.y = event.stageY;
		}
		
		private function startNewRotation():void
		{
			TweenLite.to(_rotator, ROTATE_SPEED, {rotation: 360, ease:Linear.easeNone, onComplete: startNewRotation});
		}
		
		private function animationComplete():void
		{
			if(_coordsCached)
			{
				_asset.x = _coordsCached.x;
				_asset.y = _coordsCached.y;
				_asset.scaleX = _asset.scaleY = _coordsCached.scale;
				_coordsCached = null;
			}
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function goBack():void
		{
			if(_shakeX)
			{
				TweenLite.to(_asset, _shakeSpeed, {x: _asset.x - _shakeX, onComplete: goForth});
			}
			else
			{
				TweenLite.to(_asset, _shakeSpeed, {y: _asset.y - _shakeY, onComplete: goForth});
			}
		}
		
		private function goForth():void
		{
			if(_shakeX)
			{
				TweenLite.to(_asset, _shakeSpeed, {x: _asset.x + _shakeX, onComplete: goBack});
			}
			else
			{
				TweenLite.to(_asset, _shakeSpeed, {y: _asset.y + _shakeY, onComplete: goBack});
			}
		}
	}
}