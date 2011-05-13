package net.kramhash.sounds
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public class MixInfo extends EventDispatcher
	{
		public var sound:Sound;
		public var startTime:Number;
		public var inPoisition:Number;
		public var duration:Number;
		public var position:int;
		public var length:int;
		public var isLoop:Boolean;
		public var isStay:Boolean = false;
		public var targetBar:int;
		public var volume:Number;
		
		public function MixInfo(sound:Sound, isLoop:Boolean=false, isStay:Boolean = false, bar:int=0, startTime:Number = 0, inPoisition:Number = 0, duration:Number = 0)
		{
			this.sound = sound;
			this.startTime = startTime;
			this.inPoisition = inPoisition;
			this.duration = duration;
			position = 0;
			length = Math.floor(sound.length * 44.1 / 5250);
			this.isLoop = isLoop;
			this.isStay = isStay;
			targetBar = bar;
			
		}
		
		
		public function reset():void
		{
			position = 0;
		}
		
		public function checkFinish():Boolean
		{
			var fl:Boolean = position == length;
			if(fl && isLoop == true){
				position = 0;
				return false;
			}else {
				if(fl == true){
					if(isStay == false) {
						MonsterDebugger.trace(this, targetBar);
						Sequence.removeVoice(this, targetBar);
					}
					this.dispatchEvent(new Event(Event.COMPLETE));
				}
				return fl;
			}
		}
		
		public override function toString():String
		{
			return 'MixInfo ' + this.sound
		}
	}
}