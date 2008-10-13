package com.michaelvandaniker.visualization
{
	import flash.events.Event;
	import flash.text.TextLineMetrics;
	
	import mx.core.UIComponent;
	import mx.core.UITextField;

	/**
	 * A simple implementation of IParallelCoordinateAxisRenderer.
	 * 
	 * Displays the axis a vertical line centered under a text field with the axis's label.
	 */
	public class ParallelCoordinateAxisRenderer extends UIComponent implements IParallelCoordinateAxisRenderer
	{
		/**
		 * The text field used to display the axis's label
		 */
		protected var textField:UITextField;
		
		public function ParallelCoordinateAxisRenderer()
		{
			super();
		}
		
		[Bindable(event="axisChange")]
		/**
		 * The axis this renderer should display
		 */
		public function set axis(value:ParallelCoordinateAxis):void
		{
			if(value != _axis)
			{
				_axis = value;
				invalidateSize();
				invalidateDisplayList();
				dispatchEvent(new Event("axisChange"));
			}
		}
		public function get axis():ParallelCoordinateAxis
		{
			return _axis;
		}
		private var _axis:ParallelCoordinateAxis;

		public function get axisOffsetLeft():Number
		{
			return _axisOffsetLeft;
		}
		private var _axisOffsetLeft:Number = 0;
		
		public function get axisOffsetRight():Number
		{
			return _axisOffsetRight;
		}
		private var _axisOffsetRight:Number = 1;
		
		public function get axisOffsetTop():Number
		{
			return _axisOffsetTop;
		}
		private var _axisOffsetTop:Number = 0;
		
		public function get axisOffsetBottom():Number
		{
			return _axisOffsetBottom;
		}
		private var _axisOffsetBottom:Number = 0;
		
		override protected function createChildren():void
		{
			super.createChildren();
			if(!textField)
			{
				textField = new UITextField();
				addChild(textField);
			}
		}
		
		// This axis renderer should measure as wide as the text for the label.
		override protected function measure():void
		{
			super.measure();
			if(textField)
			{
				if(axis)
					textField.text = axis.label;
				var textLineMetrics:TextLineMetrics = textField.getLineMetrics(0);
				textField.setActualSize(textLineMetrics.width + 6,textLineMetrics.height + 2);
				measuredWidth = textLineMetrics.width + 6;
				
				_axisOffsetLeft = textField.width / 2;
				_axisOffsetRight = axisOffsetLeft - 1;
				_axisOffsetTop = textField.height + 5;
			}
		}

		// Draw a vertical line centered under the text field		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			this.graphics.clear();
			if(!axis)
			{
				textField.text = "";
			}
			else
			{
				textField.text = axis.label;
				textField.move(0,0);
				
				var halfTextWidth:Number = textField.width / 2;
				graphics.lineStyle(1,0);
				graphics.moveTo(halfTextWidth,textField.height + 5);
				graphics.lineTo(halfTextWidth,height);
			}
		}
	}
}