package
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.luaye.console.C;
	
	import controller.GoCommand;
	import controller.ICommand;
	import controller.Menu3OnDrag;
	import controller.Menu3UpCommand;
	import controller.OpenWindowCommand;
	import controller.ShowTvCommand;
	import controller.TvClickCommand;
	import controller.UpdateTvNaviCommand;
	import controller.init.ConstructMenu3Command;
	import controller.init.StopGraphicsCommand;

	import flash.desktop.InteractiveIcon;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapData;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;

	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	import ktsh_util.KTSHEncoder;

	import model.BuyProvider;

	import model.DefProvider;
	import model.MovieProvider;
	import model.UserDataProvider;

	import view.AncorMediator;

	import view.AnimationMediator;

	import view.CloudsMediator;
	import view.CollectionMediator;

	import view.DragMediator;

	import view.DragMediator;

	import view.FlyButtonMediator;
	import view.RotationMediator;
	import view.SlonoDverMediator;
	import controller.init.UpdateGraphicsCommand;
	import view.windows.WindowManager;

	public class MainFlyAni extends Sprite
	{
		public static const RELEASE_MODE:Boolean = true;
		public static const SCREEN_WIDTH:int = 2048;
		public static const SCREEN_HEIGHT:int = 1536;
		
		public static var mediators:Object;
		public static var views:Object;
		public static var models:Object;

		private var _halfWidth:int;
		private var _overLastMovieId:int;
		
		public function MainFlyAni()
		{
			models = {defs: new DefProvider(), model: new UserDataProvider(), files: new MovieProvider(stage)};

			C.start(stage);
			C.fpsMonitor = true;

			var menus:Sprite = new AllMenus();
			var container:Sprite = new Sprite();
			var fon:Sprite = new Background1();
			var mist:Sprite = new Background2();
			mist.alpha = 0;

			var windows:Sprite = WindowManager.instance.container;

			this.addChild(fon);
			this.addChild(mist);

			fon.width = mist.width = stage.fullScreenWidth;
			fon.height = mist.height = stage.fullScreenHeight;

			container.x = fon.x = mist.x = stage.stageWidth / 2;
			container.y = fon.y = mist.y = stage.stageHeight / 2;
			container.addChild(menus);
			container.addChild(windows);
			this.addChild(container);

			views = menus;
			views.mist = mist;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.LOW;

			container.scaleX = container.scaleY = stage.fullScreenHeight / SCREEN_HEIGHT;

			_halfWidth = stage.fullScreenWidth / 2 / container.scaleX;

			init();
		}

		private function init():void
		{
			new ConstructMenu3Command().execute();
			new StopGraphicsCommand().execute();

			this.initView();
			this.initController();

			BuyProvider.instance;
		}
		
		private function initView():void
		{
			mediators = {};
			
			views.menu2.visible = false;
			views.menu3.visible = false;
			
			//create mediators
			
			mediators.menu1 = {};	//home
			
			mediators.menu1.btnmovies = new FlyButtonMediator(views.menu1.btnmovies);
			mediators.menu1.btncollect = new FlyButtonMediator(views.menu1.btncollect);
			mediators.menu1.diriz = new FlyButtonMediator(views.menu1.diriz);
			(mediators.menu1.diriz as FlyButtonMediator).addYshake(50, 3);
			mediators.menu1.clouds = new CloudsMediator(_halfWidth);
			mediators.menu1.dver = new SlonoDverMediator();

			var anim:Array = mediators.menu1.anim = []
			anim.push(new RotationMediator(views.menu1.diriz.anim1.getChildAt(0), 19));
			anim.push(new RotationMediator(views.menu1.diriz.anim2.getChildAt(0), 23));
			anim.push(new AnimationMediator(views.menu1.diriz.anim3));
			anim.push(new AnimationMediator(views.menu1.diriz.anim4));
			anim.push(new AnimationMediator(views.menu1.diriz.anim5));
			anim.push(new AnimationMediator(views.menu1.diriz.anim6));
			anim.push(new AnimationMediator(views.menu1.diriz.anim7));
			anim.push(new AnimationMediator(views.menu1.diriz.anim8));
			anim.push(new AncorMediator(views.menu1.diriz.anim9.getChildAt(0)));
			anim.push(new RotationMediator(views.menu1.diriz.anim11.getChildAt(0), 47));
			anim.push(new AnimationMediator(views.menu1.diriz.anim13));
			anim.push(new AnimationMediator(views.menu1.diriz.anim15));

			mediators.menu2 = {};	//movies

			views.menu2.btnhome.alpha = 0;
			mediators.menu2.btnhome = new FlyButtonMediator(views.menu2.btnhome);
			views.menu2.btncollect.alpha = 0;
			mediators.menu2.btncollect = new FlyButtonMediator(views.menu2.btncollect);

			mediators.menu2.locked = new FlyButtonMediator(views.menu2.locked);
			views.menu2.locked.alpha = 0;
			mediators.menu2.alert = new FlyButtonMediator(views.menu2.alert);
			views.menu2.alert.alpha = 0;

			mediators.menu2.tvbutton = new FlyButtonMediator(views.menu2);
			
			mediators.menu2.islands = [];
			mediators.menu2.names = [];
			mediators.menu2.miniline = [];
			mediators.menu2.tv = [];

			var miniline:Sprite = views.menu2.miniline;
			var minilineBounds:Rectangle = miniline.getBounds(miniline);
			var minX:int = _halfWidth - minilineBounds.right;
			var maxX:int = -_halfWidth - minilineBounds.x;
			miniline.x = maxX;
			var minilineDragger:DragMediator = mediators.menu2.minilineDragger = new DragMediator(miniline, minX, miniline.y, maxX, miniline.y);

			var tempMovieId:int = 1;
			_overLastMovieId = 0;
			var sprite:Sprite;
			while(_overLastMovieId == 0)
			{
				sprite = views.menu2.islands['isl'+tempMovieId];
				sprite.visible = tempMovieId == 1;
				mediators.menu2.islands[tempMovieId] = new FlyButtonMediator(sprite);

				sprite = views.menu2.names['name'+tempMovieId];
				sprite.visible = tempMovieId == 1;
				mediators.menu2.names[tempMovieId] = new FlyButtonMediator(sprite);

				sprite = views.menu2.tv['tv'+tempMovieId];
				sprite.visible = tempMovieId == 1;
				mediators.menu2.tv[tempMovieId] = new FlyButtonMediator(sprite);

				sprite = views.menu2.miniline['mini'+tempMovieId];
				mediators.menu2.miniline[tempMovieId] = new FlyButtonMediator(sprite, tempMovieId);
				minilineDragger.pushButton(sprite);

				tempMovieId++;
				if(!('isl'+tempMovieId in views.menu2.islands))
				{
					_overLastMovieId = tempMovieId;
				}
			}
			
			mediators.menu3 = {};	//collect

			views.menu3.scroll.btnmovies.alpha = 0;
			mediators.menu3.btnmovies = new FlyButtonMediator(views.menu3.scroll.btnmovies);
			views.menu3.scroll.btnhome.alpha = 0;
			mediators.menu3.btnhome = new FlyButtonMediator(views.menu3.scroll.btnhome);
			views.menu3.btnup.alpha = 0;
			mediators.menu3.btnup = new FlyButtonMediator(views.menu3.btnup);
			(mediators.menu3.btnup as FlyButtonMediator).addYshake(20, 1);

			var scroller:Sprite = views.menu3.scroll;
			var collectDragger:DragMediator = mediators.menu3.dragger = new DragMediator(scroller, 0, -scroller.height + SCREEN_HEIGHT + 100, 0, 0);
			collectDragger.pushButton(scroller);
			mediators.menu3.scroll = collectDragger;

			mediators.menu3.donate = new FlyButtonMediator(views.menu3.donate);

			for(var i:int = 0; i < models.defs.length; i++)
			{
				var movieId:int = i + 1;
				mediators.menu3[movieId] = new CollectionMediator(views.menu3[movieId], movieId, collectDragger);
			}
		}

		private function initController():void
		{
			//navi buttons
			
			var cmd:ICommand;
			cmd = new GoCommand(mediators.menu1.btnmovies, mediators.menu1.btncollect,
				mediators.menu2.btnhome, mediators.menu2.btncollect,
				views.menu1, views.menu2);
			(mediators.menu1.btnmovies as FlyButtonMediator).addClickListener(cmd);
			
			cmd = new GoCommand(mediators.menu1.btnmovies, mediators.menu1.btncollect,
				mediators.menu3.btnhome, mediators.menu3.btnmovies,
				views.menu1, views.menu3);
			(mediators.menu1.btncollect as FlyButtonMediator).addClickListener(cmd);
			
			cmd = new GoCommand(mediators.menu2.btnhome, mediators.menu2.btncollect,
				mediators.menu1.btnmovies, mediators.menu1.btncollect,
				views.menu2, views.menu1);
			(mediators.menu2.btnhome as FlyButtonMediator).addClickListener(cmd);
			
			cmd = new GoCommand(mediators.menu2.btnhome, mediators.menu2.btncollect,
				mediators.menu3.btnmovies, mediators.menu3.btnhome,
				views.menu2, views.menu3);
			(mediators.menu2.btncollect as FlyButtonMediator).addClickListener(cmd);
			
			cmd = new GoCommand(mediators.menu3.btnmovies, mediators.menu3.btnhome,
				mediators.menu1.btnmovies, mediators.menu1.btncollect,
				views.menu3, views.menu1);
			(mediators.menu3.btnhome as FlyButtonMediator).addClickListener(cmd);
			
			cmd = new GoCommand(mediators.menu3.btnmovies, mediators.menu3.btnhome,
				mediators.menu2.btnhome, mediators.menu2.btncollect,
				views.menu3, views.menu2);
			(mediators.menu3.btnmovies as FlyButtonMediator).addClickListener(cmd);

			//menu 1

			cmd = new OpenWindowCommand(WindowManager.DIRIZ);
			(mediators.menu1.diriz as FlyButtonMediator).addClickListener(cmd);

			//menu 2

			cmd = new ShowTvCommand();

			for(var i:int = 1; i < _overLastMovieId; i++)
			{
				(mediators.menu2.miniline[i] as FlyButtonMediator).addClickListener(cmd);
			}

			new UpdateTvNaviCommand().execute(1);

			(mediators.menu2.tvbutton as FlyButtonMediator).addClickListener(new TvClickCommand(cmd as ShowTvCommand));

			//menu 3

			cmd = new Menu3OnDrag();
			(mediators.menu3.dragger as DragMediator).addDragListener(cmd);

			cmd = new Menu3UpCommand();
			(mediators.menu3.btnup as FlyButtonMediator).addClickListener(cmd);

			cmd = new OpenWindowCommand(WindowManager.SVIN);
			(mediators.menu3.donate as FlyButtonMediator).addClickListener(cmd);
		}
	}
}