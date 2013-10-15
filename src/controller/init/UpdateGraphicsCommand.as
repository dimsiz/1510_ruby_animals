/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 04.10.13
 * Time: 17:11
 * To change this template use File | Settings | File Templates.
 */
package controller.init
{
	import view.*;
	import com.luaye.console.C;

	import controller.ICommand;

	import flash.display.Bitmap;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class UpdateGraphicsCommand
	{
		private var _antiscale:Number;
		private var _scale:Number;
		private var _matrix:Matrix;
		private var _dict:Dictionary;
		private var _a:Array;
		private var _started:Boolean;
		private var _onComplete:Function;

		public function UpdateGraphicsCommand()
		{
			_dict = new Dictionary();
			_a = [];
			EnterFrameBroadcaster.instance.addEventListener(Event.ENTER_FRAME, onFrame);
		}

		public function execute(scale:Number, onComplete:Function):void
		{
			_scale = scale;
			_onComplete = onComplete;
			_antiscale = 1 / _scale;
			_matrix = new Matrix(_scale, 0, 0, _scale);
			_started = true;
			this.substitute(MainFlyAni.views as DisplayObject);
		}

		private function substitute(obj:DisplayObject):void
		{
			_a.push(obj);
		}

		private function onFrame(event:Event):void
		{
			var obj:DisplayObject;
			var i:int = 1;
			while(i--)
			{
				if(_a.length)
				{
					obj = _a.shift();
					this.doAction(obj);
				}
				else if(_started)
				{
					C.log('complete');
					EnterFrameBroadcaster.instance.removeEventListener(Event.ENTER_FRAME, onFrame);
					_onComplete();
					return;
				}
			}
		}

		private function doAction(obj:DisplayObject):void
		{
			if(obj is MovieClip)
			{
				var mc:MovieClip = obj as MovieClip;
				if(_dict[mc] == null)
				{
					_dict[mc] = 1;
				}
				else if(mc.currentFrame == mc.totalFrames)
				{
					if(_dict[mc] == mc.currentFrame)
					{
						obj.x *= _scale;
						obj.y *= _scale;
						return;
					}
					else
					{
						_dict[mc] = mc.currentFrame;
					}
				}
				else
				{
					mc.nextFrame();
					_dict[mc] = mc.currentFrame;
				}
				var len:int = mc.numChildren;
				for(var i:int = 0; i < len; i++)
				{
					this.substitute(mc.getChildAt(i));
				}
				this.substitute(obj);
			}
			else if(obj is Shape)
			{
				var s:Shape = obj as Shape;
				var bounds:Rectangle = s.getBounds(s.parent);
				if(bounds.width > _antiscale && bounds.height > _antiscale)
				{
					var bd:BitmapData = new BitmapData(bounds.width * _scale, bounds.height * _scale, true, 0);
					_matrix.tx = -bounds.x*_scale;
					_matrix.ty = -bounds.y*_scale;
					bd.draw(s, _matrix);
					var bmp:Bitmap = new Bitmap(bd);
					bmp.scaleX = s.scaleX;
					bmp.scaleY = s.scaleY;
					bmp.x = bounds.x * _scale;
					bmp.y = bounds.y * _scale;
					s.parent.addChildAt(bmp, s.parent.getChildIndex(s)+1);
				}
				s.parent.removeChild(s);
			}
		}
	}
}
