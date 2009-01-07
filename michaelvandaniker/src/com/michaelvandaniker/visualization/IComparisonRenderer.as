package com.michaelvandaniker.visualization
{
	import mx.core.IUIComponent;
	
	public interface IComparisonRenderer extends IUIComponent
	{
		function get comparisonItem():ComparisonItem;
		function set comparisonItem(value:ComparisonItem):void;
		
		function get labelFunction():Function;
		function set labelFunction(value:Function):void;
		
		function get colorFunction():Function;
		function set colorFunction(value:Function):void;
		
		function get alphaFunction():Function;
		function set alphaFunction(value:Function):void;
		
		function get selected():Boolean;
		function set selected(value:Boolean):void;	
	}
}