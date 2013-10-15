/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 10.10.13
 * Time: 19:09
 * To change this template use File | Settings | File Templates.
 */
package controller
{
	import view.windows.WindowManager;

	public class OpenWindowCommand implements ICommand
	{
		private var _windowId:int;

		public function OpenWindowCommand(windowId:int)
		{
			_windowId = windowId;
		}

		public function execute(data:Object):void
		{
			WindowManager.instance.showWindow(_windowId, null);
		}
	}
}
