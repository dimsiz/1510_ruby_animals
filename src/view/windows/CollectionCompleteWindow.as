/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 11.10.13
 * Time: 17:31
 * To change this template use File | Settings | File Templates.
 */
package view.windows
{
	internal class CollectionCompleteWindow extends ALookForItemWindow
	{
		public function CollectionCompleteWindow(movieId:int)
		{
			super(movieId);
			_asset = new W02();
			this.init();
		}
	}
}
