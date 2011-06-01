package net.kramhash.utils {
	import flash.events.EventDispatcher;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.utils.ByteArray;

	/**
	 * @author mark
	 */
	public class SoundTimer extends EventDispatcher {
		private var _tick:Sound;
		private var _bytes:ByteArray;
		
		public function SoundTimer() {
			super();
			_bytes = new ByteArray();
		}
		
		
		public function start():void {
			_tick = new Sound();
			_tick.addEventListener(SampleDataEvent.SAMPLE_DATA, _count);
			_tick.play();
			
			for(var i:int = 0; i<2048; i++) {
				
			}
			
		}

		private function _count(event : SampleDataEvent) : void {
		}
		
		
	}
}
