/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 11.10.13
 * Time: 16:53
 * To change this template use File | Settings | File Templates.
 */
package view.windows
{
	import controller.DonateCommand;

	internal class SvinWindow extends AWindow
	{
		private var _donateCommand:DonateCommand;

		public function SvinWindow(data:Object)
		{
			_asset = new W10();
			_donateCommand = new DonateCommand();
			this.addFon(1400, 1300);
			this.addClickListener(_asset.btn1, donate1);
			this.addClickListener(_asset.btn2, donate3);
			this.addClickListener(_asset.btn3, donate5);
		}

		private function donate1():void
		{
			_donateCommand.execute(1);
		}

		private function donate3():void
		{
			_donateCommand.execute(3);
		}

		private function donate5():void
		{
			_donateCommand.execute(5);
		}
	}
}
