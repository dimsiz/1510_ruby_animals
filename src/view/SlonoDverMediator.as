/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 04.10.13
 * Time: 16:52
 * To change this template use File | Settings | File Templates.
 */
package view
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;

	import flash.display.Sprite;

	public class SlonoDverMediator
	{
		private var _dver:Sprite;
		private var _x1:int;
		private var _x2:int;

		public function SlonoDverMediator()
		{
			_dver = MainFlyAni.views.menu1.diriz.dver;
			_x1 = _dver.x;
			_x2 = _dver.x - _dver.width * 0.7;
			this.open();
		}

		private function open():void
		{
			TweenLite.to(_dver, 1, {x: _x2, ease:Elastic.easeIn, onComplete: close, delay: 2});
		}

		private function close():void
		{
			TweenLite.to(_dver, 0.5, {x: _x1, onComplete: open, delay: 1});
		}
	}
}
