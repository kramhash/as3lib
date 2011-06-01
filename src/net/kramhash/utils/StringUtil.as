package net.kramhash.utils {
	/**
	 * @author kramhash
	 */
	public class StringUtil {
		public static function formatNumber(value:int):String {
			return value.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,');
		}
	}
	
	
	
}
