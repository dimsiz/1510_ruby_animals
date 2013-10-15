/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 10.10.13
 * Time: 19:03
 * To change this template use File | Settings | File Templates.
 */
package view.windows
{
	import com.greensock.TweenLite;

	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	internal class DirizablWindow extends AWindow
	{
		public function DirizablWindow(data:Object)
		{
			_asset = new W01();
			this.addClickListener(_asset.btn1, goto);
			TweenLite.to(_asset.small, 0.6, {scaleX: 4.2, scaleY: 4.2, y: -169, onComplete: removeSmall});
			TweenLite.from(_asset.big, 0.3, {alpha: 0, delay: 0.3});
			this.addFon(1500, 1500);
		}

		private function goto():void
		{
			navigateToURL(new URLRequest('http://flyani.ru'));
		}

		private function removeSmall():void
		{
			_asset.removeChild(_asset.small);
		}
	}
}
