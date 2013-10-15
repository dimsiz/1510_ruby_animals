/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 03.10.13
 * Time: 18:37
 * To change this template use File | Settings | File Templates.
 */
package controller
{
	import flash.events.Event;

	import view.FlyButtonMediator;

	public class ShowTvCommand implements ICommand
	{
		private var _currentTvId:int;
		private var _nextTvId:int;
		private var _menu2Mediators:Object;
		private var _menu2Views:Object;
		private var _inProgress:Boolean;

		public function ShowTvCommand()
		{
			_menu2Mediators = MainFlyAni.mediators.menu2;
			_menu2Views = MainFlyAni.views.menu2;
			_currentTvId = 1;

			//показать локд и алерт как положено по модели
		}

		public function execute(data:Object):void
		{
			_nextTvId = data as int;
			if((_nextTvId == _currentTvId) || _inProgress) return;
			_inProgress = true;
			(_menu2Mediators.locked as FlyButtonMediator).addEventListener(Event.COMPLETE, onDisappear);
			(_menu2Mediators.locked as FlyButtonMediator).disappear();
			(_menu2Mediators.alert as FlyButtonMediator).disappear();
		}

		private function onDisappear(event:Event):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, onDisappear);
			//move tv
			var bigTvX:int = _menu2Views.tv.x + _menu2Views.tv['tv'+_currentTvId].x;
			var bigTvY:int = _menu2Views.tv.y + _menu2Views.tv['tv'+_currentTvId].y;
			var smallTvX:int = _menu2Views.miniline.x + _menu2Views.miniline['mini'+_currentTvId].x;
			var smallTvY:int = _menu2Views.miniline.y + _menu2Views.miniline['mini'+_currentTvId].y;
			(_menu2Mediators.tv[_currentTvId] as FlyButtonMediator).addEventListener(Event.COMPLETE, onTvOut);
			(_menu2Mediators.tv[_currentTvId] as FlyButtonMediator).moveTo(smallTvX - bigTvX, smallTvY - bigTvY, 0.5);
		}

		private function onTvOut(event:Event):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, onTvOut);

			_menu2Views.tv['tv'+_currentTvId].visible = false;

			_menu2Views.islands['isl'+_nextTvId].visible = true;

			var direction:int = _nextTvId > _currentTvId ? -1 : 1;
			(_menu2Mediators.islands[_currentTvId] as FlyButtonMediator).addEventListener(Event.COMPLETE, onIslandsChange);
			(_menu2Mediators.islands[_currentTvId] as FlyButtonMediator).moveTo(direction * MainFlyAni.SCREEN_WIDTH, 0);
			(_menu2Mediators.islands[_nextTvId] as FlyButtonMediator).moveFrom(- direction * MainFlyAni.SCREEN_WIDTH, 0);

			//name change
			(_menu2Mediators.names[_currentTvId] as FlyButtonMediator).addEventListener(Event.COMPLETE, onNameGone);
			(_menu2Mediators.names[_currentTvId] as FlyButtonMediator).disappear();
		}

		private function onNameGone(event:Event):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, onNameGone);

			_menu2Views.names['name'+_currentTvId].visible = false;
			_menu2Views.names['name'+_nextTvId].visible = true;

			(_menu2Mediators.names[_nextTvId] as FlyButtonMediator).appear();
		}

			private function onIslandsChange(event:Event):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, onIslandsChange);

			_menu2Views.islands['isl'+_currentTvId].visible = false;

			_menu2Views.tv['tv'+_nextTvId].visible = true;

			//move tv
			var bigTvX:int = _menu2Views.tv.x + _menu2Views.tv['tv'+_nextTvId].x;
			var bigTvY:int = _menu2Views.tv.y + _menu2Views.tv['tv'+_nextTvId].y;
			var smallTvX:int = _menu2Views.miniline.x + _menu2Views.miniline['mini'+_nextTvId].x;
			var smallTvY:int = _menu2Views.miniline.y + _menu2Views.miniline['mini'+_nextTvId].y;
			(_menu2Mediators.tv[_nextTvId] as FlyButtonMediator).addEventListener(Event.COMPLETE, onTvIn);
			(_menu2Mediators.tv[_nextTvId] as FlyButtonMediator).moveFrom(smallTvX - bigTvX, smallTvY - bigTvY, 0.5);
		}

		private function onTvIn(event:Event):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, onTvIn);
			this.onDone();
			new UpdateTvNaviCommand().execute(_currentTvId);
		}

		private function onDone(event:Event = null):void
		{
			_inProgress = false;
			_currentTvId = _nextTvId;
		}

		public function get currentTvId():int
		{
			return _currentTvId;
		}
	}
}
