/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 09.10.13
 * Time: 17:18
 * To change this template use File | Settings | File Templates.
 */
package controller
{
	import flash.events.Event;
	import model.BuyProvider;

	import model.Loader;
	import model.MovieFigureId;

	import model.MovieProvider;
	import model.UserDataProvider;

	import view.CollectionMediator;

	import view.windows.WindowManager;

	public class TvClickCommand implements ICommand
	{
		private var _showCommand:ShowTvCommand;
		private var _movies:MovieProvider;
		private var _currentMovie:int;
		private var _loader:Loader;

		public function TvClickCommand(showCommand:ShowTvCommand)
		{
			_showCommand = showCommand;
			_movies = MainFlyAni.models.files as MovieProvider;
		}

		public function execute(data:Object):void
		{
			_currentMovie = _showCommand.currentTvId;
			if(!(MainFlyAni.models.model as UserDataProvider).getMovieAvailable(_currentMovie))
			{
				//buy
				WindowManager.instance.showWindow(WindowManager.BUY_EPISODE, this);
			}
			else if(!_movies.isMovieDownloaded(_currentMovie))
			{
				//download
				WindowManager.instance.showWindow(WindowManager.START_DOWNLOAD, this);
			}
			else
			{
				this.watch();
			}
		}

		public function buy():void
		{
			WindowManager.instance.disallowMouse();
			BuyProvider.instance.buyEpisode(_currentMovie, onBought, onFail)
		}

		private function onBought():void
		{
			this.onAnything();

			var udp:UserDataProvider = MainFlyAni.models.model;

			udp.openMovie(_currentMovie);
			MainFlyAni.mediators.menu2.locked.disappear();
			MainFlyAni.mediators.menu2.alert.appear();

			var data:Array = udp.giveFiguresForMovie(_currentMovie); //результат - массив данных MFid
			var dataLength:int = data.length;
			for(var i:int = 0; i < dataLength; i++)
			{
				var coords:MovieFigureId = data[i];
				(MainFlyAni.mediators.menu3[coords.movieId] as CollectionMediator).unlockItemView(coords.figureId);

				if(coords.movieId != _currentMovie)
				{
					if(udp.getNumFigures(coords.movieId) == 5)
					{
						udp.openMovie(coords.movieId);
					}
				}
			}
			if(dataLength != 0)
			{
				WindowManager.instance.showWindow(WindowManager.MULTI_FIGURE_OPEN, data[0].movieId);
			}
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

		//---

		public function download():void
		{
			_loader = new Loader(_currentMovie);
			_loader.addEventListener(Event.COMPLETE, onLoaded);
			_loader.download();

			WindowManager.instance.hideWindow();
			WindowManager.instance.showWindow(WindowManager.LOADING, _loader);
		}

		private function onLoaded(event:Event):void
		{
			_loader.removeEventListener(Event.COMPLETE, onLoaded);
			_loader = null;

			WindowManager.instance.hideWindow();

			MainFlyAni.mediators.menu2.alert.disappear();
		}

		//---

		private function watch():void
		{
			_movies.viewMovie(_currentMovie);
		}
	}
}
