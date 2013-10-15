/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 11.10.13
 * Time: 17:36
 * To change this template use File | Settings | File Templates.
 */
package view.windows
{
	internal class MultiFigureOpenWindow extends ALookForItemWindow
	{
		public function MultiFigureOpenWindow(movieId:int)
		{
			super(movieId);
			_asset = new W09();
			this.init();
		}
	}
}
