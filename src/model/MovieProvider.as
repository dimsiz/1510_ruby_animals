package model
{
	import flash.display.Stage;

	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;

	public class MovieProvider
	{
		private var _sww:StageWebView;
		
		public function MovieProvider(stage:Stage)
		{
			_sww = new StageWebView();
			_sww.stage = stage;
			_sww.viewPort = new Rectangle(0, stage.height - stage.fullScreenHeight -100, stage.stageWidth, 100);
		}
		
		public function isMovieDownloaded(id:int):Boolean
		{
			var file:File = File.applicationStorageDirectory;
			file = file.resolvePath(id + ".mp4");
			return file.exists;
		}
		
		public function viewMovie(id:int):void
		{
			var path:String = new File(new File(this.getLocalPath(id)).nativePath).url;
			_sww.loadURL(path);
		}

		private function getLocalPath(id:int):String
		{
			var file:File = File.applicationStorageDirectory;
			file = file.resolvePath(id + ".mp4");
			return file.url;
		}
	}
}