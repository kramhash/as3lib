package net.kramhash.events
{
	import flash.events.Event;
	
	public class ScrollEvent extends Event
	{
		public static const UPDATE:String = 'update';
		public var scrollPosition:Number;
		
		public function ScrollEvent(type:String, position:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			scrollPosition = position;
		}
	}
}