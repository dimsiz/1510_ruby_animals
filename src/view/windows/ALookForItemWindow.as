/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 11.10.13
 * Time: 17:15
 * To change this template use File | Settings | File Templates.
 */
package view.windows
{
	import com.greensock.TweenLite;

	import controller.GoCommand;

	import flash.display.Sprite;
	import flash.events.Event;

	internal class ALookForItemWindow extends AWindow
	{
		private var _movieId:int;
		private var _goCommand:GoCommand;

		public function ALookForItemWindow(movieId:int)
		{
			super();
			_movieId = movieId;
			_goCommand = new GoCommand(MainFlyAni.mediators.menu2.btnhome, MainFlyAni.mediators.menu2.btncollect,
					MainFlyAni.mediators.menu3.btnmovies, MainFlyAni.mediators.menu3.btnhome,
					MainFlyAni.views.menu2, MainFlyAni.views.menu3);
		}

		protected function init():void
		{
			this.addFon(1200, 700);
			this.addClickListener(_asset.btn1, close);
			this.addClickListener(_asset.btn2, watch);
		}

		private function watch():void
		{
			this.close();
			var allMenus:Sprite = MainFlyAni.views as Sprite;
			if(allMenus.x != -MainFlyAni.views.menu3.x)
			{
				//мы в меню2
				_goCommand.addEventListener(Event.COMPLETE, onAtMenu3);
				_goCommand.execute(null);
			}
			else
			{
				//мы в меню3
				this.onAtMenu3();
			}
		}

		private function onAtMenu3(event:Event = null):void
		{
			_goCommand.removeEventListener(Event.COMPLETE, onAtMenu3);
			MainFlyAni.views.menu2.visible = false;
			var movieGroup:Sprite = MainFlyAni.views.menu3[_movieId].pic;
			MainFlyAni.mediators.menu3.scroll.go(movieGroup.x, movieGroup.y+400);
		}
	}
}
