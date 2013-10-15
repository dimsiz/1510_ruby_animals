/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 13.10.13
 * Time: 18:47
 * To change this template use File | Settings | File Templates.
 */
package view.windows
{
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;

	import model.DefProvider;

	import model.MovieFigureId;

	import view.AnimationMediator;

	internal class FigureViewWindow extends AWindow
	{
		private var _loader:Loader;
		private var _anim:AnimationMediator;

		public function FigureViewWindow(data:MovieFigureId)
		{
			_asset = new W05();
			this.addFon(900, 600);
			this.addClickListener(_asset.btn1, close);
			var def:DefProvider = MainFlyAni.models.defs;
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
			_loader.load(new URLRequest(def.getFigureUrl(data.movieId, data.figureId)));
			_asset.addChild(_loader);
		}

		override public function destroy():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaded);
			_loader.unloadAndStop();
			super.destroy();
		}

		private function onLoaded(event:Event):void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaded);
			_anim = new AnimationMediator((_loader.getChildAt(0) as Sprite).getChildAt(0) as Sprite);
		}
	}
}
