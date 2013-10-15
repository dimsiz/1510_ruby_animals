/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 14.10.13
 * Time: 0:45
 * To change this template use File | Settings | File Templates.
 */
package model
{
	import com.adobe.nativeExtensions.AppPurchase;
	import com.adobe.nativeExtensions.AppPurchaseEvent;
	import com.adobe.nativeExtensions.Transaction;
	import com.luaye.console.C;

	public class Buy4 implements IBuyAdapter
	{
		private var _target:AppPurchase;

		public function Buy4()
		{
			_target = new AppPurchase();
			_target.addEventListener(AppPurchaseEvent.PRODUCTS_RECEIVED, onReceived);
			_target.addEventListener(AppPurchaseEvent.UPDATED_TRANSACTIONS, onUpdated);
			_target.getProducts(['ru.dimsiz.flyanidev.episode4']);
		}

		public function buyEpisode(id:int, onSuccess:Function, onFail:Function):void
		{
			_target.startPayment('ru.dimsiz.flyanidev.episode4');
		}

		public function donate(amount:int, onSuccess:Function, onFail:Function):void
		{
		}

		private function onUpdated(event:AppPurchaseEvent):void
		{
			trace('onUpdated');
			trace(event.products);
			trace(event.transactions);
			trace(event.invalidIdentifiers);
			for each(var tr:Transaction in event.transactions)
			{
				trace(tr.date, tr.error, tr.productIdentifier, tr.productQuantity, tr.receipt, tr.state, tr.transactionIdentifier);
			}
		}

		private function onReceived(event:AppPurchaseEvent):void
		{
			trace('onReceived');
			trace(event.products);
			trace(event.transactions);
			trace(event.invalidIdentifiers);
		}
	}
}
