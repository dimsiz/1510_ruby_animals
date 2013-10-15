/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 09.10.13
 * Time: 19:14
 * To change this template use File | Settings | File Templates.
 */
package model
{
	import com.luaye.console.C;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;

	public class Loader extends EventDispatcher
	{
		private var _currentMovie:int;
		private var _urlStream:URLStream;

		public function Loader(movieId:int)
		{
			_currentMovie = movieId;
			_urlStream = new URLStream();
		}

		public function download():void
		{
			var url:String = MainFlyAni.models.defs.getMovieUrl(_currentMovie);
			_urlStream.addEventListener(Event.COMPLETE, onLoaded);
			_urlStream.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_urlStream.load(new URLRequest(url));
		}

		private function onProgress(event:ProgressEvent):void
		{
			C.log(event.bytesLoaded , '/', event.bytesTotal);

			var file:File = File.applicationStorageDirectory;
			file = file.resolvePath(_currentMovie + ".mp4");

			var bytes:ByteArray = new ByteArray();
			_urlStream.readBytes( bytes );

			var fs:FileStream = new FileStream();
			fs.open( file, FileMode.APPEND );
			fs.writeBytes( bytes );
			fs.close();

			this.dispatchEvent(event);
		}

		private function onLoaded(event:Event):void
		{
			C.log('complete');

			_urlStream.removeEventListener(Event.COMPLETE, onLoaded);
			_urlStream.removeEventListener(ProgressEvent.PROGRESS, onProgress);

			this.dispatchEvent(event);
		}
	}
}
