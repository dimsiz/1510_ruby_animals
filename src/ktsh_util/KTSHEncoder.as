/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 14.10.13
 * Time: 15:37
 * To change this template use File | Settings | File Templates.
 */
package ktsh_util
{
	import com.luaye.console.C;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class KTSHEncoder
	{
		private static var _instance:KTSHEncoder;

		private const M:Matrix = new Matrix();

		public function KTSHEncoder()
		{
		}

		private static function get instance():KTSHEncoder
		{
			if(_instance == null) _instance = new KTSHEncoder();
			return _instance;
		}

		public static function encode(obj:Sprite, scale:Number):ByteArray
		{
			return instance.doEncode(obj, scale);
		}

		public static function decode(ba:ByteArray):DisplayObject
		{
			return instance.doDecode(ba);
		}

		private function doEncode(obj:Sprite, scale:Number):ByteArray
		{
			return encodeContainer(obj,  scale);
		}

		private function doDecode(ba:ByteArray):DisplayObject
		{
			ba.position = 0;
			return this.decodeAsset(ba,  null);
		}

		private function hasSpriteChildren(s:DisplayObject):Boolean
		{
			var sprite:Sprite = s as Sprite;
			if(!sprite)
			{
				return false;
			}
			var len:int = sprite.numChildren;
			for(var i:int = 0; i < len; i++)
			{
				var child:Sprite = sprite.getChildAt(i) as Sprite;
				if(child)
				{
					return true;
				}
			}
			return false;
		}

		private function decodeAsset(ba:ByteArray, parent:Sprite):DisplayObject
		{
			var name:String = ba.readUTF();
			var type:Boolean = ba.readBoolean();
			var asset:Sprite = new Sprite();
			if(!type)
			{
				var loader:Loader = new Loader();
				asset.addChild(loader);
			}
			asset.name = name;
			asset.x = ba.readInt();
			asset.y = ba.readInt();
			asset.scaleX = ba.readInt() / 1000;
			asset.scaleY = ba.readInt() / 1000;
			var length:uint = ba.readUnsignedInt();
			if(parent)
			{
				parent.addChild(asset);
			}
			var bytes:ByteArray = new ByteArray();
			ba.readBytes(bytes, 0, length);
			if(type)    //container
			{
				while(bytes.position < bytes.length)
				{
					this.decodeAsset(bytes, asset);
				}
			}
			else        //graphics
			{
				loader.x = bytes.readInt();
				loader.y = bytes.readInt();
				var bytes2:ByteArray = new ByteArray();
				bytes.readBytes(bytes2, 0, length - 8);
				loader.loadBytes(bytes2);
			}
			return asset;
		}

		private function encodeContainer(sprite:DisplayObject, scale:Number):ByteArray
		{
			var ba:ByteArray = new ByteArray();
			var len:int;
			var hasSpriteChildren:Boolean = this.hasSpriteChildren(sprite);
			ba.writeUTF(sprite.name);
			ba.writeBoolean(hasSpriteChildren);
			ba.writeInt(sprite.x * scale);
			ba.writeInt(sprite.y * scale);
			ba.writeInt(sprite.scaleX * 1000);
			ba.writeInt(sprite.scaleY * 1000);
			if(!hasSpriteChildren)
			{
				var bounds:Rectangle = sprite.getBounds(sprite);
				var bmp:BitmapData = new BitmapData(bounds.width * scale, bounds.height * scale, true, 0);
				M.tx = -bounds.x * scale;
				M.ty = -bounds.y * scale;
				M.a = M.d = scale;
				bmp.draw(sprite, M);
				var data:ByteArray = PNGEncoder.encode(bmp);
				len = data.length + 8;
				ba.writeUnsignedInt(len);
				ba.writeInt(-M.tx);
				ba.writeInt(-M.ty);
				ba.writeBytes(data);
			}
			else
			{
				len = 0;
				var tempBas:Vector.<ByteArray> = new Vector.<ByteArray>();
				var container:Sprite = sprite as Sprite;
				if(!container) C.log(sprite, this.hasSpriteChildren(sprite));
				for(var i:int = 0; i < container.numChildren; i++)
				{
					var tempBa:ByteArray = this.encodeContainer(container.getChildAt(i), scale);
					tempBas.push(tempBa);
					len += tempBa.length;
				}
				ba.writeUnsignedInt(len);
				for(i = 0; i < tempBas.length; i++)
				{
					ba.writeBytes(tempBas[i]);
				}
			}
			return ba;
		}
	}
}
