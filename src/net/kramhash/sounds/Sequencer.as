package net.kramhash.sounds
{
	import br.com.stimuli.loading.BulkLoader;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	
	import nl.demonsters.debugger.MonsterDebugger;
	

	public class Sequencer extends EventDispatcher
	{
		public static const EVENT_BAR:String = 'eventBar';
		public static const PART_COMPLETE:String = 'partComplete';
		public static const MARKER:String = 'marker';
		public static const COMPLETE:String = 'complete';
		public static const LOOP_END:String = 'loopEnd';
		private static var __instance:Sequencer;
		public static function get instance():Sequencer { return __instance; }
		public static var BPM:Number;
		public static var BUFFER_SAMPLES:int = 5250;//5250;
		public static var PRE_GAP:int = 2300;
		public static var TOTAL_BAR:uint;
		public static var RESOLUTION:int = 16;
	
		
		private var _tracks:Vector.<MixInfo>;
		private var _buffers:Vector.<ByteArray>;
		private var _currentBar:uint;
		private var _currentBeat:uint = 0;
		private var _loop:Boolean;
		private var _end:int = 256;
		private var _nextBar:int = 0;
		
		private var loopStart:uint;
		private var loopEnd:uint;
		
		private var master:MasterSound;
		private var _loader:BulkLoader;
		private var _counter:MixInfo;
		private var _firstBar:int;
		public var totalBar:int;
		
		public function get looped():Boolean { return _loop; }
		
		public function Sequencer(totalBar:uint, firstBar:int = 1)
		{
			super(this);
			
			_tracks = new Vector.<MixInfo>();
			_buffers = new Vector.<ByteArray>();
			_currentBar = 1;
			_firstBar = firstBar;
			TOTAL_BAR = totalBar;
			this.totalBar = totalBar;
			master = new MasterSound();
			master.addEventListener(SampleDataEvent.SAMPLE_DATA, render);
			_loader = BulkLoader.getLoader('assets');
			_loop = false;
			Sequence.init();
			
			if(!__instance){
				__instance = this;
			}	
		}
		
		public function setLoop(start:int=0, end:int=0):void
		{
			_loop = true;
			loopStart = start;
			loopEnd = end;
		}
		
		public function loopOff():void	
		{
			_loop = false;
		}
		
		public function addCounter(s:Sound):void
		{
			_counter = new MixInfo(s);
		}
		
		
	
		
		public function addMixInfo(m:MixInfo):void
		{
			_tracks.push(m);
			master.addSound(m);
		}
		
		public function start():void
		{
			MonsterDebugger.trace(this, 'start');
			master.play();
		}
		
		public function stop():void
		{
			
		}
		
		public function get currentBar():int
		{
			return _currentBar;
		}
		
		public function set firstBar(n:int):void
		{
			_firstBar = n;
		}
		
		public function set nextBar(n:int):void
		{
			_nextBar = n;
		}
		
		private var _marker:int = 0;
		private var _markerFunc:Function;
		public function addMarker(bar:int, func:Function):void
		{
			_marker = bar;
			_markerFunc = func;
			this.addEventListener(MARKER, func);
		}
		
		
		private function render(e:SampleDataEvent):void
		{
			var s:Sound;
			var buffer:ByteArray;
			
			buffer = new ByteArray();
			s = _counter.sound;
			s.extract(buffer, BUFFER_SAMPLES, (_currentBeat++ * BUFFER_SAMPLES) + 1248);
			buffer.position = 0;
			_buffers.push(buffer);
			
			if( _currentBeat == 1) {
				dispatchEvent(new SoundEvent(SoundEvent.EVENT_BAR, _currentBar));
				
				if(Sequence.LIST[_currentBar]){
					var list:Array = Sequence.LIST[_currentBar];
					for each(var mix:MixInfo in list)
					{
						MonsterDebugger.trace(this, mix);
						mix.reset();
						addMixInfo(mix);
					}
				}
				
				_currentBar++;
				
				if(_marker == _currentBar){
					_marker = 0;
					
					this.dispatchEvent(new Event(MARKER));
					this.removeEventListener(MARKER, _markerFunc);
				}
				if(_loop)
				{
					if(_currentBar > loopEnd){
						MonsterDebugger.trace('loop', [loopStart, loopEnd, _currentBar].join(' , '));
						_currentBar = loopStart;
					}
				}else {
					if(_nextBar > 0)
					{
						_currentBar = _nextBar;
						_nextBar = 0;
					}
					else if(_currentBar > TOTAL_BAR){
						_currentBar = _firstBar;
						this.dispatchEvent(new Event(Event.COMPLETE));
					}
					else if(_currentBar == loopEnd+1){
						this.dispatchEvent(new Event(LOOP_END));
					}
				}
			}
			
			if(_currentBeat == RESOLUTION){
				_currentBeat = 0;
			}
			
			if(_tracks.length > 0){
				var l:int = _tracks.length;
				
				for(var i:int = 0; i < l; i++)
				{
					buffer = new ByteArray();
					buffer.length = BUFFER_SAMPLES;
					var info:MixInfo = _tracks[i];
					s = info.sound;
					s.extract(buffer, BUFFER_SAMPLES, (info.position++ * BUFFER_SAMPLES) + PRE_GAP);
					buffer.position = 0;
					_buffers.push(buffer);
				}
				//				position++;
				
				while( l-- ){
					if(_tracks[l].checkFinish()) _tracks.splice(l, 1);
				}
			}
			
			while (_buffers.length > 0)
			{
				var res:Number = 0.0;
				i = _buffers.length;
				while( i-- > 0 )
				{
					buffer = _buffers[i];
					res += buffer.readFloat();
					if(buffer.bytesAvailable == 0) {
						buffer.clear();
						_buffers.splice( i, 1);
					}
				}
				e.data.writeFloat(res);
			}
			while(buffer = _buffers.shift()){
				buffer.clear();
			}	
		}
	}
}