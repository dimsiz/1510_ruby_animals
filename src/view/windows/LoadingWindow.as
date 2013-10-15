/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 10.10.13
 * Time: 17:56
 * To change this template use File | Settings | File Templates.
 */
package view.windows
{
	import com.luaye.console.C;

	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;

	internal class LoadingWindow extends AWindow
	{
		private var _data:EventDispatcher;

		public function LoadingWindow(data:EventDispatcher)
		{
			_data = data;
			_data.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_asset = new W08();
			_asset.bar.scaleX = 0;
			_asset.percent.text = '0%';
			this.addFon(1200, 500);
			this.disallowClose();
		}

		override public function destroy():void
		{
			super.destroy();
			_data.removeEventListener(ProgressEvent.PROGRESS, onProgress);
		}

		public function onProgress(event:ProgressEvent):void
		{
			var ratio:Number = event.bytesLoaded / event.bytesTotal;
			_asset.bar.scaleX = ratio;
			_asset.percent.text = int(ratio * 100) + '%';
		}
	}
}
