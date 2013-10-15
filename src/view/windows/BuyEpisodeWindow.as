/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 10.10.13
 * Time: 18:53
 * To change this template use File | Settings | File Templates.
 */
package view.windows
{
	import controller.TvClickCommand;

	internal class BuyEpisodeWindow extends AWindow
	{
		private var _data:TvClickCommand;

		public function BuyEpisodeWindow(data:TvClickCommand)
		{
			_data = data;
			_asset = new W07();
			this.addClickListener(_asset.btn2, buy);
			this.addClickListener(_asset.btn1, close);
			this.addFon(1200, 700);
		}

		private function buy():void
		{
			_data.buy();
		}
	}
}
