package com.michaelvandaniker.capabilities
{
	public class SWFCapabilities
	{
		private static var hasDeterminedDebugStatus:Boolean = false;
		
		/**
		 * todo do this
		 */
		public static function get isDebug():Boolean
		{
			if(!hasDeterminedDebugStatus)
			{
				try
				{
					throw new Error();
				}
				catch(e:Error)
				{
					var stackTrace:String = e.getStackTrace();
					_isDebug = stackTrace != null && stackTrace.indexOf("[") != -1;
					hasDeterminedDebugStatus = true;
					return _isDebug;
				}
			}
			return _isDebug;
		}
		private static var _isDebug:Boolean;
	}
}