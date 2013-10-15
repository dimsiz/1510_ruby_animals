/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 13.10.13
 * Time: 16:19
 * To change this template use File | Settings | File Templates.
 */
package view
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class RotationMediator
	{
		private var _delta:int;
		private var _asset:DisplayObject;

		public function RotationMediator(asset:DisplayObject, frameLength:int)
		{
			_delta = 360 / frameLength;
			_asset = asset;
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
		}
	}
}
