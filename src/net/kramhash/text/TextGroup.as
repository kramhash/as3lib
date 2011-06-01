package net.kramhash.text {
	import flash.system.IME;
	import flash.system.Capabilities;
	import org.osflash.signals.Signal;
	import flash.events.KeyboardEvent;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * @author kramhash
	 */
	public class TextGroup extends Sprite {
		private var _text : String;
		private var _type : String;
		public var sigInput:Signal;

		public function get text() : String {
			var txt:String = '';
			for each (var tx : TextField in _texts) {
				txt += tx.text;
			}
			return txt;
		}

		public function set text(text : String) : void {
			_text = text;
		}
		
		private var _texts:Array;
		private var _letterSpace:int;
		
		private var _textFormat:TextFormat;
		
		public function get textFormat() : TextFormat {
			return _textFormat;
		}

		public function set textFormat(textFormat : TextFormat) : void {
			_textFormat = textFormat;
		}
		
		private var _textWidth:int;
		private var _length:int;
		private var _index:int;
		public function TextGroup(textFormat:TextFormat=null, textWidth:int = 20, letterSpace:int = 5, length:int=10, type:String = TextFieldType.INPUT) {
			_letterSpace = letterSpace;
			_texts = [];
			_textFormat = textFormat || new TextFormat();
			_textWidth = textWidth;
			_type = type;
			_length = length;
			_index = 0;
			sigInput = new Signal();
			_initialize();
		}
		
		private function _initialize():void {
			for(var i:int = 0; i < _length; i++) {
				var tf:TextField = addChild(new TextField()) as TextField;
				tf.defaultTextFormat = _textFormat;
				tf.type = _type;
				tf.autoSize = TextFieldAutoSize.CENTER;
				tf.multiline = false;
				if(_textFormat.font) tf.embedFonts = true;
				tf.maxChars = 1;
//				tf.border = true;
//				tf.borderColor = 0xff0000;
				tf.x = (_textWidth+_letterSpace) * i;
				tf.name = 't' + i;
				tf.addEventListener(TextEvent.TEXT_INPUT, _input);
				tf.addEventListener(FocusEvent.FOCUS_IN, _focus);
				tf.addEventListener(KeyboardEvent.KEY_DOWN, _keyDown);
				tf.addEventListener(KeyboardEvent.KEY_UP, _keyup);
				_texts.push(tf);
			}
		}
		
		
		public function focus():void {
			stage.focus = _texts[0];
		}
		
		

		

		private function _focus(event : FocusEvent) : void {
//			TextField(event.target).addEventListener(KeyboardEvent.KEY_UP, _keyup);

			if(Capabilities.hasIME) {
				IME.enabled = false;
			}
			var tf:TextField = event.target as TextField;
			var id:int = int(tf.name.substr(1));
			_index = id;
		}
		private var _lastKeyCode:int;
		private function _keyup(event : KeyboardEvent) : void {
			_lastKeyCode = event.keyCode;
			switch(event.keyCode) {
				case 8:
					if(_index > 0) {
						var tf:TextField = _texts[--_index];
						tf.text = '';
						stage.focus = tf;
					}
					break;
			}
			sigInput.dispatch(this);
		}
		
		private function _keyDown(event : KeyboardEvent) : void {
			if(_lastKeyCode == event.keyCode) return;
			_lastKeyCode = event.keyCode;
			switch(event.keyCode) {
				
			}
			
		}
		

		private function _input(event : TextEvent) : void {
			if(_index + 1 >= _texts.length) return;
			if(_lastKeyCode != 32 && event.text == '') return;
			
			if(!event.text.match(/[a-zA-Z0-9]/)){
				return;
			}
			TextField(_texts[_index]).text = event.text;
			_index++;
			var tf:TextField = _texts[_index] as TextField;
			stage.focus = tf;
			
		}
		
		
	}
}
