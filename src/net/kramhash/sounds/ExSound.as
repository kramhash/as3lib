package net.kramhash.sounds {
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;

	/**
	 * @author kramhash
	 */
	public class ExSound {
		protected var _channel:SoundChannel;
		protected var _preBuffer:int;
		protected var _sound:Sound;
		protected var _timer:Timer;
		public function get playPosition():Number {
			return _channel.position;
		}
		
		public function get channel():SoundChannel {
			return _channel;
		}
		
		public function ExSound(sound:Sound = null) {
			_sound = sound;
			_preBuffer = 90;
		}

		public function play(startTime : Number = 0, loop:int = 0, sndTrandform : SoundTransform = null) : SoundChannel {
			_channel = _sound.play(startTime, loop, sndTrandform);
			return _channel;
		}
		
		
		public function close():void {
			//_sound.close();
		}
		
		public function dispose():void {
			stop();
			close();
			_sound = null;
			_channel = null;
			
		}
		
		public function stop():void {
			if(_channel) _channel.stop();
		}


	}
}
