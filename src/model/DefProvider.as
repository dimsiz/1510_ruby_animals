/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 09.10.13
 * Time: 13:11
 * To change this template use File | Settings | File Templates.
 */
package model
{
	public class DefProvider
	{
		private var _data:Object = {
			1: {
				name: "Красный шарик"
			},
			2: {
				name: "Привычка"
			},
			3: {
				name: "Ничего"
			},
			4: {
				name: "Стирка"
			},
			5: {
				name: "Все хорошо"
			},
			6: {
				name: "Буря"
			},
			7: {
				name: "Сокровище"
			},
			8: {
				name: "Хосе, уже не тот"
			},
			9: {
				name: "Инструменты"
			}
		}

		private var _length:int;

		public function DefProvider()
		{
		}

		public function getName(id:int):String
		{
			return _data[id].name;
		}

		public function get length():int
		{
			if(_length == 0)
			{
				for(var key:String in _data)
				{
					_length = Math.max(_length, int(key))
				}
			}
			return _length;
		}

		public function getMovieUrl(id:int):String
		{
			return "http://dimsiz.ru/FlyAni/" + id + "/episode.mp4";
		}

		public function getFigureUrl(movieId:int, figureId:int):String
		{
			return "http://dimsiz.ru/FlyAni/1/" + figureId + ".swf";
		}
	}
}
