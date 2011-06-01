package net.kramhash.sounds
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class BPMTicker extends EventDispatcher
	{
		public function BPMTicker(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}