/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 09.10.13
 * Time: 13:09
 * To change this template use File | Settings | File Templates.
 */
package controller.init
{
	import flash.display.Sprite;
	import flash.display.Sprite;
	import flash.text.TextField;

	import model.DefProvider;
	import model.UserDataProvider;

	public class ConstructMenu3Command
	{
		private const TITLE0_X:int = 80;
		private const TITLE0_Y:int = 112;

		private const DELTA:int = 400;

		private const MOVIE0_X:int = -540;
		private const MOVIE0_Y:int = 26;

		private var _currentY:int = TITLE0_Y;
		private var _defs:DefProvider;
		private var _container:Sprite;
		private var _model:UserDataProvider;

		public function ConstructMenu3Command()
		{
		}

		public function execute():void
		{
			_container = MainFlyAni.views.menu3.scroll;
			_defs = MainFlyAni.models.defs;
			_model = MainFlyAni.models.model;

			this.pushFigures(1, new Figures1());
			this.pushFigures(2, new Figures2());
			this.pushFigures(3, new Figures3());
			this.pushFigures(4, new Figures4());
			this.pushFigures(5, new Figures5());
			this.pushFigures(6, new Figures6());
			this.pushFigures(7, new Figures7());
			this.pushFigures(8, new Figures8());
			this.pushFigures(9, new Figures9());

			this.updateFon();
		}

		private function pushFigures(movieId:int, picture:Object):void
		{
			var title:Object = new Menu3Title();
			title.mouseEnabled = false;
			title.mouseChildren = false;
			title.title.text = _defs.getName(movieId);
			title.title.selectable = false;
			title.num.text = _model.getNumFigures(movieId) + "/" + 5;
			title.num.selectable = false;
			title.x = TITLE0_X;
			title.y = _currentY;
			_container.addChild(title as Sprite);

			var viewStructure:Object = MainFlyAni.views.menu3[movieId] = {};
			viewStructure.num = title.num;
			viewStructure.pic = picture;

			picture.x = MOVIE0_X;
			picture.y = _currentY - TITLE0_Y + MOVIE0_Y;
			_container.addChild(picture as Sprite);

			_currentY += DELTA + picture.height;
		}

		private function updateFon():void
		{
			var x0:int = 128;
			var y0:int = 688;
			var delta:int = 1500;
			var myY:int = y0;
			while(myY < _currentY - 500)
			{
				var fon:Sprite = new Menu3Center();
				fon.x = x0;
				fon.y = myY;
				_container.addChildAt(fon, 0);

				myY += delta;
			}
			_container['niz'].y = myY;

			var hitarea:Sprite = _container['hitarea'];
			var polekrana:int = MainFlyAni.SCREEN_HEIGHT / 2;
			hitarea.height = myY + _container['niz'].height + polekrana;
			hitarea.y = hitarea.height * 0.5 - polekrana;
		}
	}
}
