/**
 * Created with IntelliJ IDEA.
 * User: Дмитрий
 * Date: 11.10.13
 * Time: 20:13
 * To change this template use File | Settings | File Templates.
 */
package model
{
	public interface IBuyAdapter
	{
		function buyEpisode(id:int, onSuccess:Function, onFail:Function):void;
		function donate(amount:int, onSuccess:Function, onFail:Function):void;
	}
}
