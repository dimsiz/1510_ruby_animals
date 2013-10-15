/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 10.10.13
 * Time: 18:28
 * To change this template use File | Settings | File Templates.
 */
package view.windows
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import view.FlyButtonMediator;

	internal class AWindow implements IWindow
	{
		protected var _asset:Object;

		private var _mediators:Array;
		private var _fon:Sprite;

		public function AWindow()
		{
			_mediators = [];
		}

		public function get asset():Sprite
		{
			(_asset as Sprite).cacheAsBitmap = true;
			return _asset as Sprite;
		}

		public function destroy():void
		{
			var len:int = _mediators.length;
			while(len--)
			{
				var mediator:FlyButtonMediator = _mediators[len];
				mediator.destroy();
			}
			_mediators.length = 0;

			this.disallowClose();
		}

		protected function addClickListener(target:Object, listener:Function):void
		{
			var mediator:FlyButtonMediator = new FlyButtonMediator(target as Sprite);
			_mediators.push(mediator);
			mediator.addClickListener(new Command(listener));
		}

		protected function close(event:MouseEvent = null):void
		{
			WindowManager.instance.hideWindow();
		}

		protected function addFon(width:int,  height:int):void
		{
			_fon = new WindowBlock(width, height);
			_asset.addChild(_fon);
			_fon.addEventListener(MouseEvent.CLICK, close);
		}

		protected function disallowClose():void
		{
			_fon.removeEventListener(MouseEvent.CLICK, close);
		}
	}
}

import controller.ICommand;

import flash.display.Sprite;

class Command implements ICommand
{
	private var _callback:Function;

	public function Command(callback:Function):void
	{
		_callback = callback;
	}

	public function execute(data:Object):void
	{
		_callback();
	}
}

class WindowBlock extends Sprite
{
	public function WindowBlock(width:int,  height:int)
	{
		var alpha:Number = MainFlyAni.RELEASE_MODE ? 0 : 0.5;
		this.graphics.beginFill(0xffff00, alpha);
		this.graphics.drawRect(-150, -350, 300, 300);
		this.graphics.drawRect(-150, -50, 100, 100);
		this.graphics.drawRect(50, -50, 100, 100);
		this.graphics.drawRect(-150, 50, 300, 300);
		this.scaleX = width / 100;
		this.scaleY = height / 100;
	}
}