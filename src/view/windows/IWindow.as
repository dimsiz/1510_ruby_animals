/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 10.10.13
 * Time: 17:46
 * To change this template use File | Settings | File Templates.
 */
package view.windows
{
	import flash.display.Sprite;

	internal interface IWindow
	{
		function get asset():Sprite;
		function destroy():void;
	}
}
