/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 10.10.13
 * Time: 15:09
 * To change this template use File | Settings | File Templates.
 */
package controller
{
	import com.luaye.console.C;

	import model.MovieFigureId;
	import model.UserDataProvider;

	import view.CollectionMediator;

	import view.windows.WindowManager;

	public class ShowItemCommand implements ICommand
	{
		private var _movieId:int;

		public function ShowItemCommand(movieId:int)
		{
			_movieId = movieId;
		}

		public function execute(data:Object):void
		{
			C.log('show figure', _movieId, data);
			var figId:int = int(data);
			WindowManager.instance.showWindow(WindowManager.COLLECTION_ITEM_VIEW, new MovieFigureId(_movieId, figId));
			(MainFlyAni.models.model as UserDataProvider).setFigureSeen(_movieId, figId);
			(MainFlyAni.mediators.menu3[_movieId] as CollectionMediator).unmarkAsNew(figId);
		}
	}
}
