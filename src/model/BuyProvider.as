/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 11.10.13
 * Time: 20:31
 * To change this template use File | Settings | File Templates.
 */
package model
{
	public class BuyProvider
	{
		private static var _instance:IBuyAdapter;

		public function BuyProvider()
		{
		}

		public static function get instance():IBuyAdapter
		{
			if(_instance == null)
			{
				_instance = new BuyAdapter2Adobe();
			}
			return _instance;
		}
	}
}
