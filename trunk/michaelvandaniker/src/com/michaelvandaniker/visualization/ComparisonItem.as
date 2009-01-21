/**
 * A ComparisonItem shows the relationship between two attributes of the objects in a data set.
 */
package com.michaelvandaniker.visualization
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class ComparisonItem
	{
		/**
		 * One attribute of the data set captured by this ComparisonItem.
		 */
		public var xField:String;
		
		/**
		 * The other attribute of the data set captured by this ComparisonItem.
		 */
		public var yField:String;
		
		/**
		 * The numerical relationship between the xField and the yField. When used in the
		 * ComparisonMatrix, this value will be the correlation coefficent.
		 */
		public var comparisonValue:Number;
		
		/**
		 * The dataProvider of the ComparisonMatrix that created this ComparisonItem.
		 */
		public var dataProvider:ArrayCollection;
		
		public function toString():String
		{
			return xField + ", " + yField + " : " + comparisonValue;
		}
	}
}