package victor.framework.interfaces
{
	import victor.framework.interfaces.IDisposable;
	
	/**
	 * ……
	 * @author 	yangsj 
	 * 			2013-8-5
	 */
	public interface IView extends IDisposable
	{
		
		/**
		 * 初始化
		 */
		function initialize():void;
		
		/**
		 * 在显示列表显示
		 */
		function show():void;
		
		/**
		 * 从显示列表移除
		 */
		function hide():void;
		
		function get data():Object;
		function set data(value:Object):void;
		
	}
}