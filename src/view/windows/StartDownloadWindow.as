/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 10.10.13
 * Time: 18:17
 * To change this template use File | Settings | File Templates.
 */
package view.windows
{
	import controller.TvClickCommand;

	internal class StartDownloadWindow extends AWindow
	{
		private var _data:TvClickCommand;

		public function StartDownloadWindow(data:TvClickCommand)
		{
			_data = data;
			_asset = new W06();
			this.addClickListener(_asset.btn2, startDownload);
			this.addClickListener(_asset.btn1, close);
			this.addFon(1200, 700);
		}

		private function startDownload():void
		{
			_data.download();
		}
	}
}
