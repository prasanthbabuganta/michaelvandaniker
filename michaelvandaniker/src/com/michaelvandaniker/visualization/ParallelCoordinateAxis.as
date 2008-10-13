package com.michaelvandaniker.visualization
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	/**
	 * An axis of the ParallelCoordinatePlot
	 */
	public class ParallelCoordinateAxis
	{
		/**
		 * The name of the field that this axis represents, as in o[fieldName]. 
		 */
		public var fieldName:String;
		
		/**
		 * The label to apply to this axis, for example "Height"
		 */
		public var label:String;
		
		/**
		 * The maximum value of this axis. If this property is not set it will be
		 * computed based on the data in the collection.
		 */
		public function set maximum(value:Number):void
		{
			userMaximum = value;
		}
		public function get maximum():Number
		{
			return userMaximum ? userMaximum : internalMaximum;
		}
		private var internalMaximum:Number;
		private var userMaximum:Number;
		
		/**
		 * The minimum value of this axis. If this property is not set it will be
		 * computed based on the data in the collection.
		 */
		public function set minimum(value:Number):void
		{
			userMinimum = value;
		}
		public function get minimum():Number
		{
			return userMinimum ? userMinimum : internalMinimum;
		}
		private var internalMinimum:Number;
		private var userMinimum:Number;
		
		/**
		 * Update the maximum and minimum values of this axis based on the data in the collection.
		 */
		public function computeExtremeValues(collection:ArrayCollection):void
		{
			if(collection && collection.length > 0)
			{
				if(!isNaN(userMaximum) || isNaN(userMinimum))
				{
					var len:int = collection.length;
					var min:Number = collection[0][fieldName];
					var max:Number = collection[0][fieldName];
					for(var a:int = 1; a < len; a++)
					{
						var value:Number = collection[a][fieldName];
						min = min > value ? value : min; 
						max = max < value ? value : max;
					}
					if(!userMaximum)
						internalMaximum = max;
					if(!userMinimum)
						internalMinimum = min;
				}
			}
			else
			{
				minimum = NaN;
				maximum = NaN;
			}
		}
	}
}