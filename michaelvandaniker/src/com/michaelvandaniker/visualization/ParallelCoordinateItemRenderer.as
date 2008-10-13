package com.michaelvandaniker.visualization
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	
	public class ParallelCoordinateItemRenderer extends UIComponent
	{
		[Bindable(event="itemChange")]
		/**
		 * The ParallelCoordinateItem this renderer should display
		 */
		public function set item(value:ParallelCoordinateItem):void
		{
			if(value != _item)
			{
				_item = value;
				invalidateDisplayList();
				dispatchEvent(new Event("itemChange"));
			}
		}
		public function get item():ParallelCoordinateItem
		{
			return _item;
		}
		private var _item:ParallelCoordinateItem;
		
		[Bindable(event="axisRenderersChange")]
		/**
		 * The ParallelCoordinateAxisRenderers to plot this item along
		 */
		public function set axisRenderers(value:Array):void
		{
			if(value != _axisRenderers)
			{
				_axisRenderers = value;
				invalidateDisplayList();
				dispatchEvent(new Event("axisRenderersChange"));
			}
		}
		public function get axisRenderers():Array
		{
			return _axisRenderers;
		}
		private var _axisRenderers:Array = [];
		
		/**
		 * The color this item should be rendered
		 */
		public function set color(value:Number):void
		{
			if(value != _color)
			{
				_color = value;
				invalidateDisplayList();
			}
		}
		public function get color():Number
		{
			return _color;
		}
		private var _color:Number = 0xff;
		
		[Bindable(event="thicknessChange")]
		/**
		 * The thickness of the line representing this item
		 */
		public function set thickness(value:Number):void
		{
			if(value != _thickness)
			{
				_thickness = value;
				invalidateDisplayList();
				dispatchEvent(new Event("thicknessChange"));
			}
		}
		public function get thickness():Number
		{
			return _thickness;
		}
		private var _thickness:Number = 1;
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			graphics.clear();
			
			if(!item || !axisRenderers)
				return;
			
			// For each sequential pair of axes render this item as line between them
			// based on the field percentages for the two axes. 
			var len:int = axisRenderers.length;
			for(var a:int = 0; a < len - 1; a++)
			{
				var currAxisRenderer:IParallelCoordinateAxisRenderer = axisRenderers[a];
				var nextAxisRenderer:IParallelCoordinateAxisRenderer = axisRenderers[a + 1];
				
				var currAxisHeight:Number = currAxisRenderer.height - 
					currAxisRenderer.axisOffsetTop - currAxisRenderer.axisOffsetBottom;
					
				var nextAxisHeight:Number = nextAxisRenderer.height - 
					nextAxisRenderer.axisOffsetTop - nextAxisRenderer.axisOffsetBottom;
				
				var x1:Number = currAxisRenderer.x + currAxisRenderer.width - currAxisRenderer.axisOffsetRight;
				var x2:Number = nextAxisRenderer.x + nextAxisRenderer.axisOffsetLeft;
				
				var topLeft:Number = currAxisRenderer.y + currAxisRenderer.axisOffsetTop;
				var topRight:Number = nextAxisRenderer.y + nextAxisRenderer.axisOffsetTop;
				
				var leftPercent:Number = item.getFieldPercentage(currAxisRenderer.axis.fieldName);
				var rightPercent:Number = item.getFieldPercentage(nextAxisRenderer.axis.fieldName);
				
				var y1:Number = topLeft + leftPercent * currAxisHeight;
				var y2:Number = topRight + rightPercent * nextAxisHeight;
				
				graphics.lineStyle(thickness,color);
				graphics.moveTo(x1,y1);
				graphics.lineTo(x2,y2);
				
				// Give at least 3 pixels to roll over
				if(thickness < 3)
				{
					graphics.lineStyle(thickness + 3,0,0);
					graphics.moveTo(x1,y1);
					graphics.lineTo(x2,y2);
				}
			}
		}		
	}
}