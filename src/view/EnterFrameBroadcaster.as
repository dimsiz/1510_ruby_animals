/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 04.10.13
 * Time: 16:05
 * To change this template use File | Settings | File Templates.
 */
package view
{
	import flash.display.Shape;

	public class EnterFrameBroadcaster extends Shape
	{
		private static var _instance:EnterFrameBroadcaster;

		public function EnterFrameBroadcaster()
		{
			super();
		}

		public static function get instance():EnterFrameBroadcaster
		{
			if(_instance == null)
			{
				_instance = new EnterFrameBroadcaster();
			}
			return _instance;
		}
	}
}
