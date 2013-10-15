/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 14.10.13
 * Time: 0:29
 * To change this template use File | Settings | File Templates.
 */
package model
{
	import com.freshplanet.ane.AirInAppPurchase.InAppPurchase;
	import com.freshplanet.ane.AirInAppPurchase.InAppPurchaseEvent;
	import com.luaye.console.C;

	internal class Buy3 implements IBuyAdapter
	{
		private var _iap:InAppPurchase;

		public function Buy3()
		{
			_iap = new InAppPurchase();
			_iap.addEventListener(InAppPurchaseEvent.PURCHASE_SUCCESSFULL, C.log);
		}

		public function buyEpisode(id:int, onSuccess:Function, onFail:Function):void
		{
			_iap.makePurchase('ru.dimsiz.flyanidev.episode4');
		}

		public function donate(amount:int, onSuccess:Function, onFail:Function):void
		{
		}
	}
}
