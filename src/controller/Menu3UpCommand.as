/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 09.10.13
 * Time: 15:42
 * To change this template use File | Settings | File Templates.
 */
package controller
{
	import view.DragMediator;

	public class Menu3UpCommand implements ICommand
	{
		public function Menu3UpCommand()
		{
		}

		public function execute(data:Object):void
		{
			(MainFlyAni.mediators.menu3.dragger as DragMediator).goFront();
		}
	}
}
