/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 09.10.13
 * Time: 20:35
 * To change this template use File | Settings | File Templates.
 */
package view
{
	import com.luaye.console.C;

	import controller.ShowItemCommand;

	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	import model.UserDataProvider;

	public class CollectionMediator
	{
		private var _opened:Array;
		private var _closed:Array;
		private var _alerts:Object;
		private var _number:TextField;
		private var _movieId:int;
		private var _command:ShowItemCommand;
		private var _dragger:DragMediator;

		public function CollectionMediator(asset:Object, movieId:int, dragger:DragMediator)
		{
			if(asset == null)
			{
				return;
				throw new Error("Не добавлена графика коллекций (см. ConstructMenu3Command) для мульта " + movieId);
			}
			_movieId = movieId;
			_dragger = dragger;
			_number = asset.num;
			_opened = [asset.pic.o1, asset.pic.o2, asset.pic.o3, asset.pic.o4, asset.pic.o5];
			_closed = [asset.pic.c1, asset.pic.c2, asset.pic.c3, asset.pic.c4, asset.pic.c5];
			_alerts = {};

			_command = new ShowItemCommand(movieId);

			var ud:UserDataProvider = MainFlyAni.models.model;

			for(var i:int = 0; i < 5; i++)
			{
				var id:int = i + 1;
				if(ud.getFigureAvailable(movieId, id))
				{
					_opened[i].visible = true;
					_closed[i].visible = false;

					this.addWatchButton(id);

					if(ud.getFigureIsNew(movieId, id))
					{
						this.markAsNew(id);
					}
				}
				else
				{
					_opened[i].visible = false;
					_closed[i].visible = true;
				}
			}
		}

		public function unlockItemView(id:int):void
		{
			_opened[id - 1].visible = true;
			_closed[id - 1].visible = false;
			this.markAsNew(id);
			this.addWatchButton(id);
			this.updateNumber();
		}

		private function markAsNew(id:int):void
		{
			if(_alerts[id])
			{
				throw new Error();
			}
			else
			{
				_alerts[id] = {};
				var container:Sprite = _opened[id - 1];
				var bounds:Rectangle = container.getBounds(container.parent);
				var view1:Sprite = _alerts[id].view = new BtnAlert();
				_alerts[id].mediator = new FlyButtonMediator(view1);
				view1.scaleX = view1.scaleY = 0.4;
				view1.mouseEnabled = view1.mouseChildren = false;
				view1.x = bounds.right - view1.width * 0.25;
				view1.y = bounds.top + view1.height * 0.25;
				container.parent.addChild(view1);
			}
		}

		public function unmarkAsNew(id:int):void
		{
			if(_alerts[id])
			{
				var view1:Sprite = _alerts[id].view;
				var mediator:FlyButtonMediator = _alerts[id].mediator;
				mediator.destroy();
				view1.parent.removeChild(view1);
				delete _alerts[id];
			}
		}

		private function addWatchButton(id:int):void
		{
			var container:Sprite = _opened[id - 1];
			var btn:BtnEmpty = new BtnEmpty();
			btn.width = container.width;
			btn.height = container.height;
			btn.x = container.x;
			btn.y = container.y;
			container.parent.addChild(btn);
			var mediator1:FlyButtonMediator = new FlyButtonMediator(btn, id);
			_closed[id - 1] = mediator1; //чтобы не потерялся
			mediator1.addClickListener(_command);
			_dragger.pushButton(btn);
		}

		private function updateNumber():void
		{
			_number.text = MainFlyAni.models.model.getNumFigures(_movieId) + '/5';
		}
	}
}