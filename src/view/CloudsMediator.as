/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 04.10.13
 * Time: 16:07
 * To change this template use File | Settings | File Templates.
 */
package view
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class CloudsMediator
	{
		private static const SPEED_1:int = 70;
		private static const SPEED_2:int = 130;
		private static const SPEED_3:int = 200;

		private var _halfWidth:int;
		private var _dataDict:Dictionary;

		public function CloudsMediator(halfWidth:int)
		{
			_halfWidth = halfWidth;
			var menu1:Object = MainFlyAni.views.menu1;
			_dataDict = new Dictionary();
			var len:int;
			var i:int;
			var width:int;
			var cloud:DisplayObject;
			len = menu1.dcloud1.numChildren;
			width = menu1.dcloud1.width;
			for(i = 0; i < len; i++)
			{
				cloud = menu1.dcloud1.getChildAt(i);
				_dataDict[cloud] = new DataObject(cloud.width, menu1.dcloud1.x, SPEED_1, width);
			}
			len = menu1.dcloud2.numChildren;
			width = menu1.dcloud2.width;
			for(i = 0; i < len; i++)
			{
				cloud = menu1.dcloud2.getChildAt(i);
				_dataDict[cloud] = new DataObject(cloud.width, menu1.dcloud2.x, SPEED_2, width);
			}
			len = menu1.dcloud3.numChildren;
			width = menu1.dcloud3.width;
			for(i = 0; i < len; i++)
			{
				cloud = menu1.dcloud3.getChildAt(i);
				_dataDict[cloud] = new DataObject(cloud.width, menu1.dcloud3.x, SPEED_3, width);
			}
			EnterFrameBroadcaster.instance.addEventListener(Event.ENTER_FRAME, onFrame);
		}

		private function onFrame(event:Event):void
		{
			for(var cloud:Object in _dataDict)
			{
				var speed:int = _dataDict[cloud].speed;
				cloud.x -= speed;
				if(!this.isVisible(cloud))
				{
					cloud.x += Math.max(_halfWidth * 2 + _dataDict[cloud].width, _dataDict[cloud].delta);
				}
			}
		}

		private function isVisible(obj:Object):Boolean
		{
			var w:int = _dataDict[obj].width;
			var offset:int = _dataDict[obj].offset;
			return obj.x + w + offset > -_halfWidth;
		}
	}
}

class DataObject
{
	public var width:int;
	public var offset:int;
	public var speed:int;
	public var delta:int;

	public function DataObject(width:int, offset:int, speed:int, delta:int)
	{
		this.width = width;
		this.offset = offset;
		this.speed = speed;
		this.delta = delta;
	}
}
