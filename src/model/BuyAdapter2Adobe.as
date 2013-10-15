/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 11.10.13
 * Time: 20:13
 * To change this template use File | Settings | File Templates.
 */
package model
{
	import com.adobe.ane.productStore.Product;
	import com.adobe.ane.productStore.ProductEvent;
	import com.adobe.ane.productStore.ProductStore;
	import com.adobe.ane.productStore.Transaction;
	import com.adobe.ane.productStore.TransactionEvent;
	import com.luaye.console.C;

	import flash.events.Event;

	import flash.net.URLLoader;

	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	internal class BuyAdapter2Adobe implements IBuyAdapter
	{
		private var _productStore:ProductStore;
		private var _onSuccess:Function;
		private var _onFail:Function;

		public function BuyAdapter2Adobe()
		{
			if (!ProductStore.isSupported)
			{
				C.log("ProductStore iOS purchases is not supported on this platform.");
				return;
			}
			_productStore = new ProductStore();
			if (!_productStore.available)
			{
				C.log("Store is disable on this device.");
				return;
			}
			C.log("ProductStore ok");
			this.getProducts();
		}

		private function getProducts():void
		{
			_productStore.addEventListener(ProductEvent.PRODUCT_DETAILS_SUCCESS,productDetailsSucceeded);
			_productStore.addEventListener(ProductEvent.PRODUCT_DETAILS_FAIL, productDetailsFailed);

			var vector:Vector.<String> = new Vector.<String>();
			vector.push("ru.dimsiz.flyanidev.episode4");
			vector.push("donation1");
			vector.push("donation3");
			vector.push("donation5");

			_productStore.requestProductsDetails(vector);
		}

		public function productDetailsSucceeded(e:ProductEvent):void
		{
			var i:uint=0;
			while(e.products && i < e.products.length)
			{
				var p:Product = e.products[i];
				i++;
				C.log(p);
			}
		}

		public function productDetailsFailed(e:ProductEvent):void
		{
			C.log('productDetailsFailed', e.error);
			var i:uint=0;
			while(e.invalidIdentifiers && i < e.invalidIdentifiers.length)
			{
				C.log(e.invalidIdentifiers[i]);
				i++;
			}
		}

		public function buyEpisode(id:int, onSuccess:Function, onFail:Function):void
		{
			_onSuccess = onSuccess;
			_onFail = onFail;
			this.buy("ru.dimsiz.flyanidev.episode" + id);
		}

		public function donate(amount:int, onSuccess:Function, onFail:Function):void
		{
			_onSuccess = onSuccess;
			_onFail = onFail;
			this.buy("donation" + amount);
		}

		private function clear():void
		{
			_onSuccess = _onFail = null;
		}


		private function buy(id:String):void
		{
			_productStore.addEventListener(TransactionEvent.PURCHASE_TRANSACTION_SUCCESS, purchaseTransactionSucceeded);
			_productStore.addEventListener(TransactionEvent.PURCHASE_TRANSACTION_CANCEL, purchaseTransactionCanceled);
			_productStore.addEventListener(TransactionEvent.PURCHASE_TRANSACTION_FAIL, purchaseTransactionFailed);
			_productStore.makePurchaseTransaction(id);
		}

		protected function purchaseTransactionSucceeded(e:TransactionEvent):void
		{
			var i:uint=0;
			var t:Transaction;
			while(e.transactions && i < e.transactions.length)
			{
				t = e.transactions[i];
				i++;
				var Base:Base64=new Base64();
				var encodedReceipt:String = Base64.Encode(t.receipt);
				var req:URLRequest = new URLRequest("https://sandbox.itunes.apple.com/verifyReceipt");
				req.method = URLRequestMethod.POST;
				req.data = "{\"receipt-data\" : \""+ encodedReceipt+"\"}";
				var ldr:URLLoader = new URLLoader(req);
				ldr.load(req);
				ldr.addEventListener(Event.COMPLETE,function(e:Event):void{

					C.log("LOAD COMPLETE: " + ldr.data);
					_productStore.addEventListener(TransactionEvent.FINISH_TRANSACTION_SUCCESS, finishTransactionSucceeded);
					_productStore.finishTransaction(t.identifier);
				});

				C.log("Called Finish on/Finish Transaction " + t.identifier);

			}

			getPendingTransaction(_productStore);
		}



		protected function purchaseTransactionCanceled(e:TransactionEvent):void{

			trace("in purchaseTransactionCanceled"+e);

			var i:uint=0;

			while(e.transactions && i < e.transactions.length)
			{
				var t:Transaction = e.transactions[i];
				i++;
				trace("FinishTransactions" + t.identifier);
				_productStore.addEventListener(TransactionEvent.FINISH_TRANSACTION_SUCCESS, finishTransactionSucceeded);
				_productStore.finishTransaction(t.identifier);
			}
			getPendingTransaction(_productStore);

			_onFail();
			this.clear();
		}

		protected function purchaseTransactionFailed(e:TransactionEvent):void
		{
			trace("in purchaseTransactionFailed"+e);
			var i:uint=0;
			while(e.transactions && i < e.transactions.length)
			{
				var t:Transaction = e.transactions[i];
				i++;
				trace("FinishTransactions" + t.identifier);
				_productStore.addEventListener(TransactionEvent.FINISH_TRANSACTION_SUCCESS, finishTransactionSucceeded);
				_productStore.finishTransaction(t.identifier);
			}
			getPendingTransaction(_productStore);

			_onFail();
			this.clear();
		}

		protected function finishTransactionSucceeded(e:TransactionEvent):void
		{
			trace("in finishTransactionSucceeded" +e);
			var i:uint=0;
			while(e.transactions && i < e.transactions.length)
			{
				var t:Transaction = e.transactions[i];
				C.log(t);
				i++;
			}

			_onSuccess();
			this.clear();
		}

		public function getPendingTransaction(prdStore:ProductStore):void
		{
			trace("pending transaction");
			var transactions:Vector.<Transaction> = prdStore.pendingTransactions;
			var i:uint=0;
			while(transactions && i<transactions.length)
			{
				var t:Transaction = transactions[i];
				trace(t);
				i++;
			}
		}
	}
}
