package com.michaelvandaniker.visualization.util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[DefaultProperty("source")]
	
	public class CSVParser extends EventDispatcher
	{
		public var source:String;
		
		[Bindable(event="rowsChange")]
		public function get rows():Array
		{
			return _rows;
		}
		public function set _rows(value:Array):void
		{
			if(value != __rows)
			{
				__rows = value;
				dispatchEvent(new Event("rowsChange"));
			}
		}
		public function get _rows():Array
		{
			return __rows;
		}
		private var __rows:Array;
		
		[Bindable(event="columnsChange")]
		public function get columns():Array
		{
			return _columns;
		}
		public function set _columns(value:Array):void
		{
			if(value != __columns)
			{
				__columns = value;
				dispatchEvent(new Event("columnsChange"));
			}
		}
		public function get _columns():Array
		{
			return __columns;
		}
		private var __columns:Array;
		
		public var fieldDelimiter:String = ",";
		
		public function parse():void
		{
			this.fieldDelimiter = fieldDelimiter;
			_columns = buildColumns();
			_rows = buildRows();
		}
			
		private function buildColumns():Array
		{
			var toReturn:Array = [];
			var rows:Array = source.split("\r\n");
			if(rows.length == 0)
				return [];
			
			var rawColumnNames:Array = rows[0].split(fieldDelimiter);
			for each(var rawColumnName:String in rawColumnNames)
			{
				var columnName:String = rawColumnName.replace("\"","").replace("\"","");
				toReturn.push(columnName);
			}
			return toReturn;
		}
		
		private function buildRows():Array
		{
			var toReturn:Array = [];
			var rawRows:Array = source.split("\r\n");
			var rowCount:int = rawRows.length;
			var columnCount:int = columns.length;
			for(var a:int = 1; a < rowCount; a++)
			{
				var row:String = rawRows[a];
				var items:Array = row.split(fieldDelimiter);
				var rowRecord:Object = new Object();
				for(var b:int = 0; b < columnCount; b++)
				{
					var cName:String = columns[b];
					var value:String = items[b].replace("\"","").replace("\"","");
					rowRecord[cName] = value;
				}
				toReturn.push(rowRecord);
			}
			return toReturn;
		}
	}
}