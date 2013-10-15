/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 04.10.13
 * Time: 13:30
 * To change this template use File | Settings | File Templates.
 */
package view
{
	public class PointDescription
	{
		public var x:int;
		public var y:int;
		public var scale:Number;

		public function PointDescription(x:int = 0, y:int = 0, scale:Number = 0)
		{
			this.x = x;
			this.y = y;
			this.scale = scale;
		}
	}
}
