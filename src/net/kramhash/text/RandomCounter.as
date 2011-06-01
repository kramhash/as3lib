package net.kramhash.text {
	import net.kramhash.array.ArrayIterator;
	import net.kramhash.utils.ArrayUtil;

	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * @author kramhash
	 */
	public class RandomCounter extends TextField {
		public static const COUNT_COMPLETE:String = 'countComplete';
		public static const TYPE_NUMERIC:int = 1;
		public static const TYPE_ALPHABET:int = 2;
		private static const NUMBER_SET:Array = ['1','2','3','4','5','6','7','8','9'];
		private var _value:String;
		private var _type:int;
		private var _dummyStrings:Array;
		private var _delay:int = 6;
		private var _count:int;
		private var _res:Array;
		
		public function RandomCounter(type:int = 1) {
			
			_type = type;
			selectable = false;
			_count = 0;
			multiline = false;
			tabEnabled = false;
						
		}
		public function init(value:String):void {
			_value = value;
			_dummyStrings = [];
			_res = [];
			var i:int = _value.length;
			var j:int = 0;
			
			while (i--) {
				if(j > 0 && (j % 3) == 0) {
					_dummyStrings.push(new ArrayIterator([',']));
					_res.unshift(',');
				}
				_dummyStrings.push(new ArrayIterator( ArrayUtil.randomize(NUMBER_SET)));
				_res.unshift(_value.charAt(i));
				j++;
			}
		}

		private function _render(event : Event) : void {
			var tmp:String = '', i:int;
			
			if(_count++ > _delay) {
				_dummyStrings.shift();
				if(_dummyStrings.length > 0 && Array(_dummyStrings[_dummyStrings.length-1]).length == 1){
					_count = _delay;
				}else{
					_count = 0;
				}
			}
			
			i = _dummyStrings.length;
			while (i--) {
				var it:ArrayIterator = _dummyStrings[i];
				if(!it.hasNext()) it.reset();
				tmp += String(it.next());
			}
			
			
			
			i = _dummyStrings.length-1;
			
			while(++i < _res.length) {
				tmp += _res[i];
			}
			text = tmp;
			
			if(_dummyStrings.length == 0) {
				this.dispatchEvent(new Event(COUNT_COMPLETE));
				removeEventListener(Event.ENTER_FRAME, _render);
			}
		}

		public function start() : void {
			this.addEventListener(Event.ENTER_FRAME, _render);
		}
		
		public function dispose():void {
			
		}
	}
}
