package com.michaelvandaniker.visualization
{
	import flash.utils.Dictionary;

	/**
	 * An item to plot on the ParallelCoordinatePlot. This class provides information
	 * to the renderers necessary to display a single item from the ParallelCoordinatePlot's
	 * dataProvider.
	 */
	public class ParallelCoordinateItem
	{
		/**
		 * A raw object from the dataProvider
		 */
		public var item:Object;
		
		/**
		 * A dictionary containing information about how far along each axis the item should be placed.
		 * For example, if the "radius" field ranges between 1 and 10 and this item has a radius of 4,
		 * fieldPercentages[radius] == .4
		 */
		private var fieldPercentages:Dictionary = new Dictionary();
		
		/**
		 * Constructor
		 */
		public function ParallelCoordinateItem(item:Object)
		{
			this.item = item;
		}
		
		/**
		 * Returns the entry from the fieldPercentages Dictionary for fieldName.
		 */
		public function getFieldPercentage(fieldName:String):Number
		{
			return fieldPercentages[fieldName];
		}
		
		/**
		 * Compute the field percentage as described in the comment for fieldPercentages.
		 */
		public function computeFieldPercentage(fieldName:Object,minimum:Number,maximum:Number):Number
		{
			fieldPercentages[fieldName] = 1 - (maximum - item[fieldName]) / (maximum - minimum);
			return fieldPercentages[fieldName];
		}	
	}
}