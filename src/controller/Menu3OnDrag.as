/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 09.10.13
 * Time: 15:22
 * To change this template use File | Settings | File Templates.
 */
package controller
{
	import flash.display.Sprite;

	import view.FlyButtonMediator;

	public class Menu3OnDrag implements ICommand
	{
		private const DONATE_Y_0:int = 258;
		private const DONATE_Y_1:int = -302;

		public function Menu3OnDrag()
		{
		}

		public function execute(data:Object):void
		{
			var newY:int = data.y;
			var btnUp:FlyButtonMediator = MainFlyAni.mediators.menu3.btnup;
			if(newY == 0)
			{
				btnUp.disappear();
			}
			else
			{
				if(!btnUp.appearsOnScreen)
				{
					btnUp.appear();
				}
			}
			var btnDonate:Sprite = MainFlyAni.views.menu3.donate;
			btnDonate.y = Math.max(DONATE_Y_0 + newY, DONATE_Y_1);
		}
	}
}
