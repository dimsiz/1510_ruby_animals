/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 11.10.13
 * Time: 14:03
 * To change this template use File | Settings | File Templates.
 */
package model
{
	import com.luaye.console.C;
	import com.milkmangames.nativeextensions.ios.StoreKit;
	import com.milkmangames.nativeextensions.ios.events.StoreKitErrorEvent;
	import com.milkmangames.nativeextensions.ios.events.StoreKitEvent;

	internal class BuyAdapter implements IBuyAdapter
	{
		private var _onSuccess:Function;
		private var _onFail:Function;

		public function BuyAdapter()
		{
			if (!StoreKit.isSupported())
			{
				C.log("Store Kit iOS purchases is not supported on this platform.");
				return;
			}
			StoreKit.create();
			if (!StoreKit.storeKit.isStoreKitAvailable())
			{
				C.log("Store is disable on this device.");
				return;
			}
			StoreKit.storeKit.addEventListener(StoreKitEvent.PURCHASE_SUCCEEDED,onPurchaseSuccess);
			StoreKit.storeKit.addEventListener(StoreKitEvent.PURCHASE_CANCELLED,onPurchaseUserCancelled);
			StoreKit.storeKit.addEventListener(StoreKitErrorEvent.PURCHASE_FAILED,onPurchaseFailed);
		}

		public function buyEpisode(id:int, onSuccess:Function, onFail:Function):void
		{
			onSuccess(); return;
			_onSuccess = onSuccess;
			_onFail = onFail;
			StoreKit.storeKit.purchaseProduct("episode" + id);
		}

		public function donate(amount:int, onSuccess:Function, onFail:Function):void
		{
			onSuccess(); return;
			_onSuccess = onSuccess;
			_onFail = onFail;
			StoreKit.storeKit.purchaseProduct("donation" + amount);
		}

		private function onPurchaseSuccess(event:StoreKitEvent):void
		{
			_onSuccess();
			this.clear();
		}

		private function onPurchaseUserCancelled(event:StoreKitEvent):void
		{
			_onFail();
			this.clear();
		}

		private function onPurchaseFailed(event:StoreKitErrorEvent):void
		{
			_onFail();
			this.clear();
		}

		private function clear():void
		{
			_onSuccess = _onFail = null;
		}
	}
}
