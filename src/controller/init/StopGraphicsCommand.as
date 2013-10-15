/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 09.10.13
 * Time: 15:58
 * To change this template use File | Settings | File Templates.
 */
package controller.init
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class StopGraphicsCommand
	{
		public function StopGraphicsCommand()
		{
		}

		public function execute():void
		{
			this.act(MainFlyAni.views as DisplayObject);
		}

		private function act(obj:DisplayObject):void
		{
			var io:InteractiveObject = obj as InteractiveObject;
			if(io) io.mouseEnabled = false;

			var cont:DisplayObjectContainer = obj as DisplayObjectContainer;
			if(cont)
			{
				var len:int = cont.numChildren;
				for(var i:int = 0; i < len; i++)
				{
					var child:MovieClip = cont.getChildAt(i) as MovieClip;
					if(child)
					{
						this.act(child);
					}
				}
			}

			var mc:MovieClip = obj as MovieClip;
			if(mc) mc.stop();
		}
	}
}
