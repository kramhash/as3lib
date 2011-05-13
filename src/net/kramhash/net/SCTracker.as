package net.kramhash.net
{
	import com.omniture.AppMeasurement;
	
	import flash.display.LoaderInfo;

	public class SCTracker extends Tracker
	{
		private static var __tracker:AppMeasurement;
		
		public static function track(page:String):void
		{
			__tracker.pageName = page;
			__tracker.track();
		}
		
		public static function initialize():void
		{
			__tracker = new AppMeasurement();
			__tracker.account = "sonysceijpplaystationcom";
			__tracker.pageURL = LoaderInfo.url;
			__tracker.charSet = 'UTF-8';
			__tracker.visitorNamespace = 'sonyscei';
			__tracker.trackingServer = 'sonyscei.112.2o7.net';
			__tracker.debugTracking = true;
			__tracker.trackLocal = true;
			__tracker.currencyCode = 'JPY';
			__tracker.cookieDomainPeriods = 3;
			
		}
	}
}