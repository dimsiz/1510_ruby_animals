package model
{
	import com.luaye.console.C;

	import flash.net.SharedObject;

	public class UserDataProvider
	{
		private const FREE_MOVIES:Array = [1, 2, 3];

		private var _data:Object;
			/*{
				1:
				{
					movieAvailable: true,
					figures:
					{
						1:
						{
							isNew: true,
							isBought: true
						},
						2:
						{
							
						}
					}
				}
			}*/
		private var _sharedObject:SharedObject;
		private var _lastMovieId:int;
		
		public function UserDataProvider()
		{
			_sharedObject = SharedObject.getLocal("userData");
			if(_sharedObject.data["userData"])
			{
				_data = _sharedObject.data["userData"];
			}
			else
			{
				_data = {};
				_sharedObject.data["userData"] = _data;
			}
		}
		
		public function getMovieAvailable(id:int):Boolean
		{
			if(!_data[id])
			{
				this.initMovieData(id);
			}
			return _data[id].available;
		}
		
		public function getFigureAvailable(movieId:int, figureId:int):Boolean
		{
			if(_data[movieId])
			{
				return _data[movieId].figures[figureId].isBought;
			}
			else
			{
				this.initMovieData(movieId);
				return false;
			}
		}
		
		public function getFigureIsNew(movieId:int, figureId:int):Boolean
		{
			if(_data[movieId])
			{
				return _data[movieId].figures[figureId].isNew;
			}
			else
			{
				this.initMovieData(movieId);
				return false;
			}
		}

		public function getNumFigures(movieId:int):int
		{
			if(_data[movieId])
			{
				var obj:Object = _data[movieId].figures;
				var i:int = 0;
				for(var key:String in obj)
				{
					if(_data[movieId].figures[key].isBought)
					{
						i++;
					}
				}
				return i;
			}
			else
			{
				this.initMovieData(movieId);
				return 0;
			}
		}
		
		public function openMovie(id:int):void
		{
			C.log('openMovie', id);
			if(!_data[id])
			{
				this.initMovieData(id);
			}
			_data[id].available = true;
			
			this.saveChangesToDisk();
		}
		
		private function openFigure(movieId:int, figureId:int):void
		{
			C.log('openFigure', movieId, figureId);
			if(!_data[movieId])
			{
				this.initMovieData(movieId);
			}
			_data[movieId].figures[figureId].isBought = true;
			_data[movieId].figures[figureId].isNew = true;
			
			this.saveChangesToDisk();
		}
		
		public function setFigureSeen(movieId:int, figureId:int):void
		{
			if(!_data[movieId])
			{
				this.initMovieData(movieId);
			}
			var wasNew:Boolean = _data[movieId].figures[figureId].isNew;
			if(wasNew)
			{
				_data[movieId].figures[figureId].isNew = false;
				
				this.saveChangesToDisk();
			}
		}

		public function giveFiguresForMovie(movieId:int):Array
		{
			//даем 2 фигурки к тому мульту (если все есть и так - ничего не даем)
			if(!_data[movieId])
			{
				this.initMovieData(movieId);
			}
			var obj:Object = _data[movieId].figures;
			var result:Array = [];
			var figId:String;
			var movId:String;
			for(figId in obj)
			{
				if(!obj[figId].isBought)
				{
					this.openFigure(movieId, int(figId));
					result.push(new MovieFigureId(movieId, int(figId)));
					if(result.length == 2) return result;
				}
			}
			for(movId in _data)
			{
				obj = _data[movId].figures;
				for(figId in obj)
				{
					if(!obj[figId].isBought)
					{
						this.openFigure(int(movId), int(figId));
						result.push(new MovieFigureId(int(movId), int(figId)));
						if(result.length == 2) return result;
					}
				}
			}
			return result;
		}

		public function openRandomFigure():MovieFigureId
		{
			var initMovId:int = Math.random() * this.lastMovieId + 1;
			var i:int = initMovId;
			var secondLap:Boolean;
			while(i <= this.lastMovieId)
			{
				var figId:int = this.getRandomUnopenedFigure(i);
				if(figId != -1)
				{
					this.openFigure(i, figId);
					return new MovieFigureId(i, figId);
				}

				if(i == this.lastMovieId)
				{
					i = 1;
				}
				else if(i == initMovId)
				{
					if(secondLap)
					{
						return null;
					}
					else
					{
						secondLap = true;
						i++;
					}
				}
				else
				{
					i++;
				}
			}
			return null;
		}

		private function getRandomUnopenedFigure(movieId:int):int
		{
			var init:int = Math.random() * 5 + 1;
			var i:int = init;
			var secondLap:Boolean;
			while(i <= 5)
			{
				if(!this.getFigureAvailable(movieId, i))
				{
					return i;
				}

				if(i == 5)
				{
					i = 1;
				}
				else if(i == init)
				{
					if(secondLap)
					{
						return -1;
					}
					else
					{
						secondLap = true;
						i++;
					}
				}
				else
				{
					i++;
				}
			}
			return -1;
		}
		
		private function initMovieData(id:int):void
		{
			_data[id] = {
				available: FREE_MOVIES.indexOf(id) != -1,
				figures:{}
			};
			for(var i:int = 1; i < 6; i++)
			{
				this.initFigureData(id, i);
			}
		}
		
		private function initFigureData(movieId:int, figureId:int):void
		{
			_data[movieId].figures[figureId] = {
				isNew: false,
				isBought: false
			};
		}
		
		private function saveChangesToDisk():void
		{
			_sharedObject.flush();
		}

		public function get lastMovieId():int
		{
			if(_lastMovieId == 0)
			{
				for(var movId:String in _data)
				{
					_lastMovieId = Math.max(_lastMovieId, int(movId));
				}
			}
			return _lastMovieId;
		}
	}
}