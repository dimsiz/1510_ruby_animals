/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 09.10.13
 * Time: 16:46
 * To change this template use File | Settings | File Templates.
 */
package controller
{
	import model.MovieProvider;
	import model.UserDataProvider;

	public class UpdateTvNaviCommand implements ICommand
	{
		public function UpdateTvNaviCommand()
		{
		}

		public function execute(data:Object):void
		{
			var movieId:int = int(data);
			if(!(MainFlyAni.models.model as UserDataProvider).getMovieAvailable(movieId))
			{
				MainFlyAni.mediators.menu2.locked.appear();
			}
			else if(!(MainFlyAni.models.files as MovieProvider).isMovieDownloaded(movieId))
			{
				MainFlyAni.mediators.menu2.alert.appear();
			}
		}
	}
}
