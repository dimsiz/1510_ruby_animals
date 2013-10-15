/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 13.10.13
 * Time: 15:47
 * To change this template use File | Settings | File Templates.
 */
package view
{
	import com.luaye.console.C;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;

	import view.EnterFrameBroadcaster;

	public class AnimationMediator
	{
		private var _next:Dictionary;
		private var _current:DisplayObject;

		public function AnimationMediator(asset:Sprite)
		{
			_next = new Dictionary();
			var len:int = asset.numChildren;
			C.log('anim', len);
			var child:DisplayObject;
			var next:DisplayObject;
			for(var i:int = 0; i < len - 1; i++)
			{
				child = asset.getChildAt(i);
				next = asset.getChildAt(i + 1);
				_next[child] = next;
				child.visible = false;
			}
			child = asset.getChildAt(len - 1);
			next = asset.getChildAt(0);
			_next[child] = next;
			child.visible = false;

			_current = asset.getChildAt(0);
			_current.visible = true;
			this.start();
		}

		public function pause():void
		{
			EnterFrameBroadcaster.instance.removeEventListener(Event.ENTER_FRAME, onFrame);
		}

		public function start():void
		{
			EnterFrameBroadcaster.instance.addEventListener(Event.ENTER_FRAME, onFrame);
		}

		private function onFrame(event:Event):void
		{
			_current.visible = false;
			_current = _next[_current];
			_current.visible = true;
		}
	}
}
