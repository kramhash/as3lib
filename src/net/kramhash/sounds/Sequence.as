package net.kramhash.sounds
{
	import br.com.stimuli.loading.BulkLoader;
	
	import jp.nium.utils.ArrayUtil;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public class Sequence
	{
		
		public static var LIST:Array = [];
		public static const PART_LENGTH:int = 16;
		public static const SOLO_PART:Object = {start:9, length:2};
		public static const LOOP_PART:Object = {start:49, length:1};
		public function Sequence()
		{
			
		}
		
		public static function init():void
		{
			var loader:BulkLoader = BulkLoader.getLoader('assets');
			LIST[1] = [new MixInfo(loader.getSound('loop'), false, true, 1)];
//			LIST[5] = [new MixInfo(loader.getSound('intro'), false, true, 5)];
//			LIST[9] = [new MixInfo(loader.getSound('solo'), false, true, 9)];
//			LIST[25] = [new MixInfo(loader.getSound('loop'), false, true, 25)];
//			LIST[41] = [ new MixInfo(loader.getSound('interval'), false, true, 41)];
		}
		
		public static function addTrack(pos:int, m:MixInfo):void
		{
			if(!LIST[pos]){
				LIST[pos] = [];
			}
			m.targetBar = pos;
			LIST[pos].push(m);

		}
		
		public static function removeVoice(v:MixInfo, bar:int):void
		{
			MonsterDebugger.trace('remove sound', [v, bar]);
			var a:Array = LIST[bar];
			if(!a) return;
			
			for(var i:int= 0; i<a.length; i++)
			{
				MonsterDebugger.trace('remove sound', a[i] == v);
				if(a[i] == v){
					MonsterDebugger.trace('remove sound', v);
					a.splice(i, 1);
					break;
				}
			}

		}
	}
}