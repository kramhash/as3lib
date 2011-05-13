package net.kramhash.graphics
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class GraphicUtil
	{
		public static const RADIAN:Number = Math.PI/180;
		public static const RIGHT_RADIAN:Number = Math.PI/2;
		
		public function GraphicUtil()
		{
		}
		
		public static function drawBitmapData(g:Graphics, bmd:BitmapData, matrix:Matrix=null, repeat:Boolean = false, rect:Rectangle=null, smooth:Boolean = false):void
		{
			var w:Number = rect ? rect.width : bmd.width;
			var h:Number = rect ? rect.height : bmd.height;
			var x:Number = rect ? rect.x : 0;
			var y:Number = rect ? rect.y : 0;
			g.beginBitmapFill(bmd, matrix, repeat, smooth);
			g.drawRect(x,y,w,h);
			g.endFill();
		}
		
		public static function drawPie(g:Graphics, x:int, y:int, radius:int, startAngle:Number, endAngle:Number, div:int = 10):void
		{
			startAngle = startAngle * RADIAN;
			endAngle = endAngle * RADIAN;
			var rad:Number = (endAngle - startAngle) /div;
			
			for(var i:int = 0; i<=div; i++) {
				var r:Number = rad * i;
				var ct:Number = startAngle + r;
				var ax:Number = Math.cos(ct) * radius + x;
				var ay:Number = Math.sin(ct) * radius + y;
				var cx:Number = ax + radius * Math.tan(rad/2) * Math.cos(ct - RIGHT_RADIAN);
				var cy:Number = ay + radius * Math.tan(rad/2) * Math.sin(ct - RIGHT_RADIAN);
				if(i == 0){
					g.moveTo(ax, ay);
				}else{
					g.curveTo(cx, cy, ax, ay);
				}
			}
			
			g.lineTo(x, y);
		}
	}
}