/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 11.10.13
 * Time: 16:00
 * To change this template use File | Settings | File Templates.
 */
package model
{
	public class MovieFigureId
	{
		private var _mid:int;
		private var _fid:int;

		public function MovieFigureId(movieId:int,  figureId:int)
		{
			_mid = movieId;
			_fid = figureId;
		}

		public function get movieId():int
		{
			return _mid;
		}

		public function get figureId():int
		{
			return _fid;
		}
	}
}
