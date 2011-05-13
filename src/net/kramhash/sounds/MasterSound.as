package net.kramhash.sounds
{
	import de.polygonal.ds.DLL;
	
	import flash.events.EventDispatcher;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class MasterSound extends Sound
	{
		public static const EVENT_BAR:String = 'bar_count';
		public static var BUFFER_SAMPLES:int = 5250;
		public static var PRE_GAP:int = 2250;
		private var _channel:SoundChannel;
		private var _mute:Boolean;
		private var _latency:Number;
		private var _sounds:Array;
		private var _ev:EventDispatcher;
		private var _currentSounds:Array;
		private var _buffers:Vector.<ByteArray>;
		
		public function MasterSound()
		{
			super();
			_mute = false;
			//addEventListener(SampleDataEvent.SAMPLE_DATA, _onSampleData);
			_sounds = [];
			_currentSounds = [];
			_buffers = new Vector.<ByteArray>();

		}
		
		public override function play(startTime:Number=0, loops:int=0, sndTransform:SoundTransform=null):SoundChannel
		{
			_channel = super.play(startTime, loops, sndTransform);
			_mute = false;
			MonsterDebugger.trace(this, 'test');
			return _channel;
		}
		
		
		public function addSound(m:MixInfo):void
		{
			_currentSounds.push(m);
		}
		
		
		
		
		private function _onSampleData(e:SampleDataEvent):void
		{
			/*
			var currentTime:Number = e.position / SAMPLE_RATE;
			if(_channel) {
				//MonsterDebugger.trace(this, [_channel.position, e.position, e.position / SAMPLE_RATE - _channel.position].join(' , '));
				_latency = currentTime - _channel.position;
			}
			*/
			
			if(_currentSounds.length > 0){
				var l:int = _currentSounds.length;
				var buffer:ByteArray;
				
				for(var i:int = 0; i < l; i++)
				{
					buffer = new ByteArray();
					buffer.length = BUFFER_SAMPLES;
					var info:MixInfo = _currentSounds[i];
					var s:Sound = info.sound;
					s.extract(buffer, BUFFER_SAMPLES, (info.position++ * BUFFER_SAMPLES) + PRE_GAP);
					buffer.position = 0;
					_buffers.push(buffer);
				}
				

				
				
				while (_buffers.length > 0)
				{
					var res:Number = 0.0;
					i = _buffers.length;
					while( i-- > 0 )
					{
						buffer = _buffers[i];
						res += buffer.readFloat();
						if(buffer.bytesAvailable == 0) _buffers.splice( i, 1);
					}
					e.data.writeFloat(res);
				}
				while(buffer = _buffers.shift()){
					buffer.clear();
				}
				
//				position++;
				
			}else {
				
			}
		}
	}
}