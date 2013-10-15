/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 11.10.13
 * Time: 17:32
 * To change this template use File | Settings | File Templates.
 */
package view.windows
{
	internal class CollectionCompletePlusEpisodeWindow extends ALookForItemWindow
	{
		public function CollectionCompletePlusEpisodeWindow(movieId:int)
		{
			super(movieId);
			_asset = new W03();
			this.init();
		}
	}
}
