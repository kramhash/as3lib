package net.kramhash.geom
{
	public class ColorUtil
	{
		public function ColorUtil()
		{
		}
		
		public static function colorSplit(color:uint):Array
		{
			return [color >> 16 & 0xff, color >> 8 & 0xff, color & 0xff];
		}
		
		
	}
}