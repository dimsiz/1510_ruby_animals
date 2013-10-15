/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 11.10.13
 * Time: 17:34
 * To change this template use File | Settings | File Templates.
 */
package view.windows
{
	internal class FigureOpenedWindow extends ALookForItemWindow
	{
		public function FigureOpenedWindow(movieId:int)
		{
			super(movieId);
			_asset = new W04();
			this.init();
		}
	}
}
