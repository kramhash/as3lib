package net.kramhash.graphics
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public class Dot
	{
		private static var DOT_TEXTURE:BitmapData;
		
		public static function getTexture():BitmapData
		{
			return DOT_TEXTURE;
		}
		public static function init(lineWidth:int, lineSpace:int, color:uint = 0x0):void
		{
			var size:int = (lineWidth + lineSpace), i:int = 0, j:int, rect:Rectangle = new Rectangle(0, 0, lineWidth, lineWidth);
			DOT_TEXTURE = new BitmapData(size, size, true, 0x0);
			DOT_TEXTURE.fillRect(rect, color);
			rect.x = lineSpace;
			rect.y = lineSpace;
			DOT_TEXTURE.fillRect(rect, color);

			
		}
		
		public static function draw(g:Graphics, x:int, y:int, width:int, height:int):void
		{
			g.beginBitmapFill(DOT_TEXTURE);
			g.drawRect(x,y,width,height);
			g.endFill();
		}
		
		private var texture:BitmapData;
		
		public function Dot(matrix:Array, width:int, color:uint = 0x0, backgroundColor:uint = 0xffffffff)
		{
			var x:int, y:int, len:int = matrix.length;
			
			texture = new BitmapData(width, int(len/width), true, 0x0);
			texture.lock();
			for(var i:int = 0; i < matrix.length; i++)
			{
				x = int(i % width);
				y = int(i / width);
				texture.setPixel32(x, y, matrix[i] == 1 ? color : backgroundColor);
			}
			texture.unlock();
		}
		
		
		public function draw(g:Graphics, x:int, y:int, width:int, height:int):void
		{
			g.beginBitmapFill(texture);
			g.drawRect(x,y,width,height);
			g.endFill();
		}
	}
}