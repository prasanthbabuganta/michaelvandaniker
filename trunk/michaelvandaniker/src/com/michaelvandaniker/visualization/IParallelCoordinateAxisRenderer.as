package com.michaelvandaniker.visualization
{
	import mx.core.IUIComponent;
	
	/**
	 * An interface to be implemented by components rendering parallel coordinate axes
	 */
	public interface IParallelCoordinateAxisRenderer extends IUIComponent
	{
		/**
		 * The ParallelCoordinateAxis this axis renderer should display.
		 */
		function get axis():ParallelCoordinateAxis;
		function set axis(value:ParallelCoordinateAxis):void;
		
		// In order to determine where the ParallelCoordinateItemRenderer should draw
		// lines, it needs to know the location of the actual axis within the axis renderer.
		// The following four getters allow the implementor to expose this information. 
		
		/**
		 * The distance from the left side of the axis renderer to what 
		 * item renderer should consider the actual axis.
		 */
		function get axisOffsetLeft():Number;
		
		/**
		 * The distance from the right side of the axis renderer to what 
		 * item renderer should consider the actual axis.
		 */
		function get axisOffsetRight():Number;
		
		/**
		 * The distance from the top of the axis renderer to what 
		 * item renderer should consider the actual axis.
		 */
		function get axisOffsetTop():Number;
		
		/**
		 * The distance from the bottom of the axis renderer to what 
		 * item renderer should consider the actual axis.
		 */
		function get axisOffsetBottom():Number;
	}
}