/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 13.10.13
 * Time: 17:22
 * To change this template use File | Settings | File Templates.
 */
package view
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class AncorMediator
	{
		private var _delta:int;
		private var _asset:DisplayObject;

		public function AncorMediator(asset:DisplayObject)
		{
			_asset = asset;
			_delta = 1;
			this.start();
		}

		public function pause():void
		{
			EnterFrameBroadcaster.instance.removeEventListener(Event.ENTER_FRAME, onFrame);
		}

		public function start():void
		{
			EnterFrameBroadcaster.instance.addEventListener(Event.ENTER_FRAME, onFrame);
		}

		private function onFrame(event:Event):void
		{
			_asset.rotation += _delta;
			if(_asset.rotation > 10)
			{
				_delta *= -1;
			}
			else if(_asset.rotation < 0)
			{
				_delta *= -1;
			}
		}
	}
}
