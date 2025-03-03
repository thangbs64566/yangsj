package victor.core.interfaces
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	
	/**
	 * ……
	 * @author 	yangsj 
	 * 			2013-6-21
	 */
	public interface IItem extends IElement
	{
		
		/**
		 * 初始化
		 */
		function initialize():void;
		
		/**
		 * 刷新
		 */
		function refresh():void;
		
		/**
		 * 移除显示列表
		 */
		function removeFromParent(delay:Number = 0):void;
		
		/**
		 * 是否选择
		 */
		function get selected():Boolean;
		function set selected(value:Boolean):void;
		
		/**
		 * item同类型标记
		 */
		function get mark():int;
		function set mark(value:int):void;
		
		/**
		 * 可见性
		 */
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		/**
		 * 宽度
		 */
		function get itemWidth():Number;
		
		/**
		 * 高度
		 */
		function get itemHeight():Number;
		
		/**
		 * 本地坐标转换的全局坐标
		 */
		function get globalPoint():Point;
		
		/**
		 * 父容器
		 * @param value
		 */
		function get parentTarget():DisplayObjectContainer;
		function set parentTarget(value:DisplayObjectContainer):void;
		
	}
}