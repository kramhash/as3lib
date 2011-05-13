package net.kramhash.sounds
{
	import flash.events.Event;
	
	public class SoundEvent extends Event
	{
		public static var EVENT_BAR:String = 'bar event';
		public var barCount:int;
		
		public function SoundEvent(type:String, barCount:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.barCount = barCount;
		}
	}
}