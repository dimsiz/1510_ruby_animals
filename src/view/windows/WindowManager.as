/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 10.10.13
 * Time: 17:39
 * To change this template use File | Settings | File Templates.
 */
package view.windows
{
	import com.greensock.TweenLite;

	import flash.display.Sprite;

	public class WindowManager
	{
		public static const DIRIZ:int = 1;
		public static const COLLECTION_COMPLETE:int = 2;
		public static const COLLECTION_COMPLETE_PLUS_EPISODE:int = 3;
		public static const FIGURE_OPENED:int = 4;
		public static const COLLECTION_ITEM_VIEW:int = 5;
		public static const START_DOWNLOAD:int = 6;
		public static const BUY_EPISODE:int = 7;
		public static const LOADING:int = 8;
		public static const MULTI_FIGURE_OPEN:int = 9;
		public static const SVIN:int = 10;

		private static var _instance:WindowManager;

		public var container:Sprite;

		private var _lib:Array;
		private var _currentWindow:IWindow;

		public function WindowManager()
		{
			container = new Sprite();
			_lib = [];

			_lib[DIRIZ] = DirizablWindow;
			_lib[COLLECTION_COMPLETE] = CollectionCompleteWindow;
			_lib[COLLECTION_COMPLETE_PLUS_EPISODE] = CollectionCompletePlusEpisodeWindow;
			_lib[FIGURE_OPENED] = FigureOpenedWindow;
			_lib[COLLECTION_ITEM_VIEW] = FigureViewWindow;
			_lib[START_DOWNLOAD] = StartDownloadWindow;
			_lib[BUY_EPISODE] = BuyEpisodeWindow;
			_lib[LOADING] = LoadingWindow;
			_lib[MULTI_FIGURE_OPEN] = MultiFigureOpenWindow;
			_lib[SVIN] = SvinWindow;
		}

		public static function get instance():WindowManager
		{
			if(_instance == null)
			{
				_instance = new WindowManager();
			}
			return _instance;
		}

		public function showWindow(id:int, params:Object):void
		{
			if(_currentWindow) throw new Error();
			var wClass:Class = _lib[id];
			_currentWindow = new wClass(params);
			container.addChild(_currentWindow.asset);
			TweenLite.from(_currentWindow.asset, 0.5, {alpha: 0});
		}

		public function hideWindow():void
		{
			TweenLite.to(_currentWindow.asset, 0.5, {alpha: 0, onComplete: container.removeChild, onCompleteParams:[_currentWindow.asset]});
			_currentWindow.destroy();
			_currentWindow = null;
		}

		public function allowMouse():void
		{
			container.mouseChildren = true;
		}

		public function disallowMouse():void
		{
			container.mouseChildren = false;
		}
	}
}
