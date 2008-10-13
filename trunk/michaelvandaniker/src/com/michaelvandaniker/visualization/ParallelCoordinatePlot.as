package com.michaelvandaniker.visualization
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;

	/**
	 * A parallel coordinate plot.
	 * 
	 * See http://en.wikipedia.org/wiki/Parallel_coordinates for details
	 */
	public class ParallelCoordinatePlot extends UIComponent
	{
		/**
		 * A UIComponent to hold the axis renderers
		 */
		protected var axesContainer:UIComponent;
		
		/**
		 * A UIComponent to hold the item renderers
		 */
		protected var itemRendererContainer:UIComponent;
		
		/**
		 * The ParallelCoordinateItems extracted from the dataProvider
		 */
		protected var parallelCoordinateItems:Array = [];
		
		/**
		 * The renders for each item in the dataProvider
		 */
		protected var itemRenderers:Array = [];
		
		/**
		 * A flag indicating that the axes renderers need to be recreated
		 */
		protected var axesRenderersDirty:Boolean = true;
		
		/**
		 * A flag indicating that the dataProvider has changed
		 */
		protected var dataProviderDirty:Boolean = true;
		
		/**
		 * A flag indicating that the itemRenderer factory has changed
		 */
		protected var itemRendererFactoryDirty:Boolean = true;
		
		public function ParallelCoordinatePlot()
		{
			super();
		}
		
		[Bindable(event="itemRendererChange")]
		/**
		 * A factory used to create renderers for the items in the dataProvider  
		 */
		public function set itemRenderer(value:IFactory):void
		{
			if(value != _itemRenderer)
			{
				_itemRenderer = value;
				itemRendererFactoryDirty = true;
				invalidateProperties();
				invalidateDisplayList();
				dispatchEvent(new Event("itemRendererChange"));
			}
		}
		public function get itemRenderer():IFactory
		{
			return _itemRenderer;
		}
		private var _itemRenderer:IFactory = new ClassFactory(ParallelCoordinateItemRenderer);
		
		[Bindable(event="axisRenderersChange")]
		/**
		 * An array of IParallelCoordinateAxisRenderers containing, from left to right, the axis renderers.
		 */
		public function set axisRenderers(value:Array):void
		{
			if(value != _axisRenderers)
			{
				_axisRenderers = value;
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
				dispatchEvent(new Event("axisRenderersChange"));
			}
		}
		public function get axisRenderers():Array
		{
			return _axisRenderers;
		}
		private var _axisRenderers:Array = [];
		
		[Bindable(event="axesChange")]
		/**
		 * The axes that make up this parallel coordinate plot.
		 */
		public function set axes(value:Array):void
		{
			if(value != _axes)
			{
				_axes = value;
				dispatchEvent(new Event("axesChange"));
			}
		}
		public function get axes():Array
		{
			return _axes;
		}
		private var _axes:Array = [];
		
		[Bindable(event="dataProviderChange")]
		/**
		 * An ArrayCollection of Objects to render on this ParallelCoordinatePlot
		 */
        public function get dataProvider():ArrayCollection
        {
			return _dataProvider;
        }
		public function set dataProvider(value:ArrayCollection):void
		{
			if(_dataProvider != value)
			{
				if (_dataProvider)
					_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, handleCollectionChange);
				_dataProvider = value;
	            _dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, handleCollectionChange);
	            dispatchEvent(new Event("dataProviderChange"));
	            dataProviderDirty = true;
	            invalidateProperties();
	            invalidateDisplayList();
			}
        }
        private var _dataProvider:ArrayCollection;
        
        protected function handleCollectionChange(event:CollectionEvent):void
        {
        	dataProviderDirty = true;
        	invalidateProperties();
        }
        
        override protected function createChildren():void
        {
        	super.createChildren();
        	if(!axesContainer)
        	{
        		axesContainer = new UIComponent();
        		addChild(axesContainer);
        	}
        	if(!itemRendererContainer)
        	{
        		itemRendererContainer = new UIComponent();
        		addChild(itemRendererContainer);
        	}
        } 
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			// The array of axis renderers has changed. Just throw out all the old ones and regenerate.
			if(axesRenderersDirty)
			{
				while(axesContainer.numChildren > 0)
				{
					axesContainer.removeChildAt(0);
				}
				for each(var axisRenderer:IParallelCoordinateAxisRenderer in axisRenderers)
				{
					 axesContainer.addChild(DisplayObject(axisRenderer));
				}
				axesRenderersDirty = false;
			}
			
			// The itemRenderer factory has changed, so we need to throw away all the ParallelCoordinateItemRenderers
			if(itemRendererFactoryDirty)
			{
				while(itemRendererContainer.numChildren > 0)
				{
					itemRendererContainer.removeChildAt(0);
				}
				itemRenderers = [];
				itemRendererFactoryDirty = false;
			}
			
			if(dataProviderDirty)
			{
				updateAxisExtremeValues();
				updateParallelCoordinateItems();
				syncItemRenderersWithCollection();
				dataProviderDirty = false;
			}
		}
		
		/**
		 * Update the max an min values of each axis if they haven't been set already
		 */
		private function updateAxisExtremeValues():void
		{
			for each(var axis:ParallelCoordinateAxis in axes)
			{
				axis.computeExtremeValues(dataProvider);
			}
		}
		
		/**
		 * Generate a ParallelCoordinateItems for each item in the dataProvider
		 */ 
		private function updateParallelCoordinateItems():void
		{
			parallelCoordinateItems = [];
			for each(var o:Object in dataProvider)
			{
				var pci:ParallelCoordinateItem = new ParallelCoordinateItem(o);
				for each(var axis:ParallelCoordinateAxis in axes)
				{
					pci.computeFieldPercentage(axis.fieldName,axis.minimum,axis.maximum);
					parallelCoordinateItems.push(pci);
				}
			}
		}
		
		/**
		 * Make sure there is one ParallelCoordinateItemRenderer for each ParallelCoordinateItem
		 */
		private function syncItemRenderersWithCollection():void
		{
			for(var a:int = 0; a < parallelCoordinateItems.length; a++)
			{
				var renderer:ParallelCoordinateItemRenderer;
				if(itemRenderers.length >= a)
				{
					renderer = itemRenderer.newInstance();
					itemRenderers.push(renderer);
					itemRendererContainer.addChild(renderer);
				}
				renderer = ParallelCoordinateItemRenderer(itemRenderers[itemRenderers.length - 1]);
				renderer.axisRenderers = axisRenderers;
				renderer.item = ParallelCoordinateItem(parallelCoordinateItems[a]);
			}
			while(itemRenderers.length > parallelCoordinateItems.length)
			{
				itemRendererContainer.removeChild(itemRenderers.pop());
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			layoutAxisRenderers();
			updateItemRenderers();
		}
		
		/**
		 * Space the axis renderers evenly along the width of the component
		 */
		protected function layoutAxisRenderers():void
		{
			if(axisRenderers.length == 0)
				return;

			axesContainer.move(0,0);
			axesContainer.setActualSize(width,height);
			
			var availableWidth:Number = width - axisRenderers[axisRenderers.length - 1].measuredWidth + 
				axisRenderers[axisRenderers.length - 1].axisOffsetLeft;
			var numAxisRenderers:Number = axisRenderers.length;
			for(var a:int = 0; a < numAxisRenderers; a++)
			{
				var axisRenderer:IParallelCoordinateAxisRenderer = IParallelCoordinateAxisRenderer(axisRenderers[a]);
				var axisX:Number;
				if(a == 0)
				{
					axisX = 0;
				}
				else if(a < numAxisRenderers - 1)
				{
					axisX = availableWidth * a / (numAxisRenderers - 1);
					axisX -= axisRenderer.measuredWidth / 2;
				}
				else
				{
					axisX = width - axisRenderer.measuredWidth;
				}
				axisRenderer.move(axisX,0);
				axisRenderer.setActualSize(axisRenderer.measuredWidth,height);
			}
		}
		
		/**
		 * Trigger a redraw of the item renderers by setting their size
		 */
		protected function updateItemRenderers():void
		{
			for each(var renderer:ParallelCoordinateItemRenderer in itemRenderers)
			{
				renderer.setActualSize(width,height);
			}
		}
	}
}