package controller
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import view.FlyButtonMediator;

	public class GoCommand extends EventDispatcher implements ICommand
	{
		public static const MOVE_SPEED:Number = 1;

		private var _views:Object;
		
		private var _btn1:FlyButtonMediator;
		private var _btn2:FlyButtonMediator;
		private var _btn3:FlyButtonMediator;
		private var _btn4:FlyButtonMediator;
		private var _view1:Sprite;
		private var _view2:Sprite;
		
		public function GoCommand(btn1:Object, btn2:Object, btn3:Object, btn4:Object, view1:Object, view2:Object)
		{
			_views = MainFlyAni.views;
			
			_btn1 = btn1 as FlyButtonMediator;
			_btn2 = btn2 as FlyButtonMediator;
			_btn3 = btn3 as FlyButtonMediator;
			_btn4 = btn4 as FlyButtonMediator;
			_view1 = view1 as Sprite;
			_view2 = view2 as Sprite;
		}
		
		public function execute(data:Object):void
		{
			_view2.visible = true;
			_btn1.addEventListener(Event.COMPLETE, onDisappear);
			_btn1.disappear();
			_btn2.disappear();
		}
		
		private function onDisappear(event:Event):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, onDisappear);
			TweenLite.to(_views, MOVE_SPEED, {x: -_view2.x, y: -_view2.y, onComplete: onMoved});
			var mistAlpha:Number;
			if(_view2 == _views.menu1)
			{
				mistAlpha = 0;
			}
			else
			{
				mistAlpha = 0.5;
			}
			TweenLite.to(_views.mist, MOVE_SPEED, {alpha: mistAlpha});

			if(MainFlyAni.views.menu1.visible)
			{
				var a:Array = MainFlyAni.mediators.menu1.anim;
				var len:int = a.length;
				while(len--)
				{
					a[len].pause();
				}
			}
		}
		
		private function onMoved():void
		{
			_btn3.appear();
			_btn4.appear();
			_view1.visible = false;
			this.dispatchEvent(new Event(Event.COMPLETE));

			if(MainFlyAni.views.menu1.visible)
			{
				var a:Array = MainFlyAni.mediators.menu1.anim;
				var len:int = a.length;
				while(len--)
				{
					a[len].start();
				}
			}
		}
	}
}