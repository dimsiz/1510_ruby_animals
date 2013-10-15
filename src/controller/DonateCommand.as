/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 11.10.13
 * Time: 16:36
 * To change this template use File | Settings | File Templates.
 */
package controller
{
	import model.BuyProvider;
	import model.MovieFigureId;
	import model.UserDataProvider;

	import view.CollectionMediator;

	import view.windows.WindowManager;

	public class DonateCommand implements ICommand
	{
		private var _udp:UserDataProvider;

		public function DonateCommand()
		{
			_udp = MainFlyAni.models.model;
		}

		public function execute(data:Object):void
		{
			var amount:int = int(data);
			BuyProvider.instance.donate(amount, onSuccess, onFail);
			WindowManager.instance.disallowMouse();
		}

		private function onSuccess():void
		{
			this.onAnything();
			var coords:MovieFigureId = _udp.openRandomFigure();
			if(coords)
			{
				(MainFlyAni.mediators.menu3[coords.movieId] as CollectionMediator).unlockItemView(coords.figureId);

				var openedEpisode:Boolean = _udp.getNumFigures(coords.movieId) == 5;
				if(openedEpisode)
				{
					if(this.openEpisode(coords.movieId))
					{
						WindowManager.instance.showWindow(WindowManager.COLLECTION_COMPLETE_PLUS_EPISODE, coords.movieId);
					}
					else
					{
						WindowManager.instance.showWindow(WindowManager.COLLECTION_COMPLETE, coords.movieId);
					}
				}
				else
				{
					WindowManager.instance.showWindow(WindowManager.FIGURE_OPENED, coords.movieId);
				}
			}
		}

		private function openEpisode(startMovieId:int):Boolean
		{
			var i:int = startMovieId;
			var secondLap:Boolean;
			while(i <= _udp.lastMovieId)
			{
				if(!_udp.getMovieAvailable(i))
				{
					_udp.openMovie(i);
					return true;
				}

				if(i == _udp.lastMovieId)
				{
					i = 1;
				}
				else if(i == startMovieId)
				{
					if(secondLap)
					{
						return false;
					}
					else
					{
						secondLap = true;
						i++;
					}
				}
				else
				{
					i++;
				}
			}
			return false;
		}

		private function onFail():void
		{
			this.onAnything();
		}

		private function onAnything():void
		{
			WindowManager.instance.hideWindow();
			WindowManager.instance.allowMouse();
		}
	}
}
