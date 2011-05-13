package net.kramhash.text
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	
	import net.kramhash.geom.ColorUtil;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class ExTextField extends TextField
	{
		private static const byteToPerc:Number = 1 / 0xff;
		private var _selectionColor:uint;
		private var _selectedColor:uint;
		private var _textColor:uint;
		private var colorMatrixFilter:ColorMatrixFilter;
		
		
		public function ExTextField(textColor:uint, selectionColor:uint, selectedColor:uint)
		{
			super();
			_textColor = textColor;
			_selectionColor = selectionColor;
			_selectedColor = selectedColor;
			colorMatrixFilter = new ColorMatrixFilter();
			updateFilter();
			
			this.addEventListener(FocusEvent.FOCUS_IN, _focus);
			this.addEventListener(FocusEvent.FOCUS_OUT, _blur);
		}
		
		private function _focus(e:FocusEvent):void
		{
			updateFilter();
			this.addEventListener(Event.ENTER_FRAME, updateFilter);
		}
		
		private function _blur(e:FocusEvent):void
		{
			this.removeEventListener(Event.ENTER_FRAME, updateFilter);
		}
		
		
		public function updateFilter(e:Event = null):void
		{
			this.textColor = 0xff0000;
			
			var o:Array = ColorUtil.colorSplit(_selectionColor);
			var r:Array = ColorUtil.colorSplit(_textColor);
			var g:Array = ColorUtil.colorSplit(_selectedColor);
			
			var ro:int = o[0];
			var go:int = o[1];
			var bo:int = o[2];
			
			var rr:Number = ((r[0] - 0xff) - o[0]) * byteToPerc + 1;
			var rg:Number = ((r[1] - 0xff) - o[1]) * byteToPerc + 1;
			var rb:Number = ((r[2] - 0xff) - o[2]) * byteToPerc + 1;
			
			var gr:Number = ((g[0] - 0xff) - o[0]) * byteToPerc + 1 - rr;
			var gg:Number = ((g[1] - 0xff) - o[1]) * byteToPerc + 1 - rg;
			var gb:Number = ((g[2] - 0xff) - o[2]) * byteToPerc + 1 - rb;
			
			colorMatrixFilter.matrix = [rr, gr, 0, 0, ro, rg, gg, 0, 0, go, rb, gb, 0, 0, bo, 0, 0, 0, 1, 0];
			
			this.filters = [colorMatrixFilter];
		}
	}
}