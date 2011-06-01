package net.kramhash.utils {
	/**
	 * @author kramhash
	 */
	public class ArrayUtil {
		public static function randomize(a:Array):Array {
			var b:Array = a.slice();
			b.sort(_sortRandom);
			return b;
		}
		
		private static function _sortRandom(a:*, b:*):int {
			a,b;
			return Math.round(Math.random() * 1) ? 1 : -1;
		}
	}
}
