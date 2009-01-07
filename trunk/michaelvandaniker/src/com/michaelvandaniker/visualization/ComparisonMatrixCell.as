/**
 * The ComparisonMatrixCell is the default itemRenderer used by the ComparisonMatrix.
 * Visually, it is a square colored to correspond to the comparisonValue of a ComparisonItem. 
 */
package com.michaelvandaniker.visualization
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.formatters.NumberFormatter;
	
	/**
	 *  The color of the background of a renderer when the user rolls over it.
	 *
	 *  @default 0xB2E1E1
	 */
	[Style(name="rollOverColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  The color of the background of a renderer when the user selects it.
	 *
	 *  @default 0x7FCEFF
	 */
	[Style(name="selectionColor", type="uint", format="Color", inherit="yes")]

	public class ComparisonMatrixCell extends UIComponent implements IComparisonRenderer
	{
		public function ComparisonMatrixCell()
		{
			super();
			addEventListener(MouseEvent.ROLL_OVER,handleRollOver);
			addEventListener(MouseEvent.ROLL_OUT,handleRollOut);
		}
		
		/**
		 * The TextField that will show details about the comparisonValue
		 */
		private var textField:UITextField;
		
		/**
		 * A mask for the textField so it won't spill over into other cells
		 */
		private var textFieldMask:Shape;
		
		/**
		 * Whether or not the user is currently rolled over this ComparisonMatrixCell
		 */
		private var isRolledOver:Boolean = false;
		
		[Bindable(event="labelFunctionChange")]
		/**
		 * The function used to determine what text should be shown in the cell.
		 * 
		 * The function should take a comparisonItem as an argument and return a String.
		 * If a function is not applied, no label is shown.
		 */
		public function set labelFunction(value:Function):void
		{
			if(value != _labelFunction)
			{
				_labelFunction = value;
				invalidateDisplayList();
				dispatchEvent(new Event("labelFunctionChange"));
			}
		}
		public function get labelFunction():Function
		{
			return _labelFunction;
		}
		private var _labelFunction:Function;
		
		[Bindable(event="alphaFunctionChange")]
		/**
		 * A function used to determine the alpha value of this interior of this ComparisonMatrixCell.
		 * 
		 * The function should take a comparisonItem as an argument and return a Number.
		 *  
		 * The default behavior is to use the absolute value of the comparisonItem's comparisonValue.
		 */
		public function set alphaFunction(value:Function):void
		{
			if(value != _alphaFunction)
			{
				_alphaFunction = value;
				invalidateDisplayList();
				dispatchEvent(new Event("alphaFunctionChange"));
			}
		}
		public function get alphaFunction():Function
		{
			return _alphaFunction;
		}
		private var _alphaFunction:Function;
		
		[Bindable(event="colorFunctionChange")]
		/**
		 * A function used to determine the color of this interior of this ComparisonMatrixCell.
		 * 
		 * The function should take a comparisonItem as an argument and return a uint.
		 *  
		 * The default behavior is to use red (0xff0000) for comparisonValues less than 0
		 * and blue (0xff) for all other values.
		 */
		public function set colorFunction(value:Function):void
		{
			if(value != _colorFunction)
			{
				_colorFunction = value;
				invalidateDisplayList();
				dispatchEvent(new Event("colorFunctionChange"));
			}
		}
		public function get colorFunction():Function
		{
			return _colorFunction;
		}
		private var _colorFunction:Function;
		
		[Bindable(event="comparisonMatrixItemChange")]
		/**
		 * The comparisonItem this ComparisonMatrixItem should render.
		 */
		public function set comparisonItem(value:ComparisonItem):void
		{
			if(value != _comparisonMatrixItem)
			{
				_comparisonMatrixItem = value;
				invalidateDisplayList();
				dispatchEvent(new Event("comparisonMatrixItemChange"));
			}
		}
		public function get comparisonItem():ComparisonItem
		{
			return _comparisonMatrixItem;
		}
		private var _comparisonMatrixItem:ComparisonItem;
		
		[Bindable(event="selectedChange")]
		/**
		 * Whether or not this ComparisonMatrixCell should appear selected.
		 */
		public function set selected(value:Boolean):void
		{
			if(value != _selected)
			{
				_selected = value;
				invalidateDisplayList();
				dispatchEvent(new Event("selectedChange"));
			}
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		private var _selected:Boolean = false;
		
		override protected function createChildren():void
		{
			super.createChildren();
			if(!textField)
			{
				textField = new UITextField();
				textFieldMask = new Shape();
				textField.mask = textFieldMask;
				addChild(textFieldMask);
				addChild(textField);
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			this.graphics.clear();
			if(comparisonItem)
			{
				var nf:NumberFormatter = new NumberFormatter();
				nf.precision = 4;
				
				// If a label function was specified, use that function, otherwise
				// manufacture a label from the comparisonItem.
				var label:String = "";
				if(labelFunction != null)
					label = labelFunction.apply(this,[comparisonItem]);
				textField.text = label;
				
				// Determine the color and alpha value of the interior of the ComparisonMatrixCell
				// based on the selected or isRolledOver properties or the comparisonValues itself. 
				var color:Number;
				var alpha:Number = 1;
				if(selected)
				{
					color = getStyle("selectionColor");
				}
				else if(isRolledOver)
				{
					color = getStyle("rollOverColor");
				}
				else
				{
					if(colorFunction != null)
						color = colorFunction.apply(this,[comparisonItem]);
					else
						color = comparisonItem.comparisonValue > 0 ? 0xff0000 : 0xff;
					
					if(alphaFunction != null)
						alpha = alphaFunction.apply(this,[comparisonItem]);
					else
						alpha = Math.abs(comparisonItem.comparisonValue);
				}
				
				// Draw the box
				this.graphics.lineStyle(1,0);
				this.graphics.beginFill(color,alpha);
				this.graphics.drawRect(0,0,width,height);
				this.graphics.endFill();
				
				textFieldMask.graphics.clear();
				textFieldMask.graphics.beginFill(0,1);
				textFieldMask.graphics.drawRect(0,0,width,height);
				textFieldMask.graphics.endFill();
			}
			else
			{
				// Clear the textField's text in the event that
				// there is no comparisonItem (however that may arise). 
				textField.text = "";
			}
		}
		
		// Handler for rolling the mouse over the ComparisonMatrixCell.
		// Set the isRolledOver property and invalidate.
		private function handleRollOver(event:MouseEvent):void
		{
			isRolledOver = true;
			invalidateDisplayList();
		}
		
		// Handler for rolling the mouse out of the ComparisonMatrixCell.
		// Set the isRolledOver property and invalidate.
		private function handleRollOut(event:MouseEvent):void
		{
			isRolledOver = false;
			invalidateDisplayList();
		}
	}
}