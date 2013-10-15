/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 04.10.13
 * Time: 13:38
 * To change this template use File | Settings | File Templates.
 */
package model
{
	import flash.geom.Point;

	public class Utils
	{
		public function Utils()
		{
		}

		public static function areNear(p1:Point, p2:Point, delta:int):Boolean
		{
			return areNearLinear(p1.x, p2.x, delta) && areNearLinear(p1.y, p2.y, delta);
		}

		private static function areNearLinear(x:int, y:int, delta:int):Boolean
		{
			if(x < y)
			{
				return x + delta > y;
			}
			else
			{
				return x - delta < y;
			}
		}

		public static function inBounds(min:int, max:int, value:int):int
		{
			return Math.min(max, Math.max(min,  value));
		}
	}
}
