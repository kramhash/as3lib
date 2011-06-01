package net.kramhash.ui {
	import net.kramhash.events.ScrollEvent;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	[Event(name="update", type="net.kramhash.events.ScrollEvent")]
	
	public class Scroll extends Sprite
	{
		public static const UPDATE:String = 'update';
		protected var handle:InteractiveObject;
		protected var dummyArea:Shape;
		protected var _inertia:Boolean;
		public function set intertia(v:Boolean):void {
			_inertia = v;
		}
		
		public function get inertia():Boolean{
			return _inertia;
		}
		
		private var offset:Point;
		private var vector:Point;
		private var lastPosition:Point;
		private var _dragged:Boolean;
		
		public function move(y:Number):void
		{
			handle.y = (dummyArea.height - handle.height) * y;
		}
		
		public function get value():Number {
			return (handle.y) / (dummyArea.height - handle.height);
		}
		
		public function set value(n:Number):void
		{
			handle.y = (dummyArea.height - handle.height) * n;
		}
		
		override public function set height(v:Number):void
		{
			dummyArea.graphics.beginFill(0x0,0);
			dummyArea.graphics.drawRect(0,0,10,v);
			dummyArea.graphics.endFill();
		}
		
		
		
		public function Scroll(_handle:InteractiveObject=null)
		{
			_inertia = true;
			_dragged = false;
			dummyArea = addChildAt(new Shape(), 0) as Shape;
			vector = new Point();
			lastPosition = new Point();
			if(_handle) handle = _handle;
			if(handle is Sprite)
			{
				Sprite(handle).buttonMode = true;
			}
			else if(handle is SimpleButton)
			{
				SimpleButton(handle).useHandCursor = true;
			}
			else if(handle is MovieClip)
			{
				MovieClip(handle).buttonMode = true;
			}
			offset = new Point();
			addEventListener(Event.ADDED_TO_STAGE, _onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, _onRemoved);
		}
		
		public function initialize():void
		{
			
		}
		
		protected function _onAdded(e:Event):void
		{
			unbind();
			this.addEventListener(Event.ENTER_FRAME, _drag);
			handle.addEventListener(MouseEvent.MOUSE_DOWN, _startDrag);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, _onWheel);
		}
		
		protected function _onRemoved(e:Event):void
		{
			unbind();
		}
		
		
		private function unbind():void
		{
			try{
				this.removeEventListener(Event.ENTER_FRAME, _drag);
				stage.removeEventListener(MouseEvent.MOUSE_WHEEL, _onWheel);
				handle.removeEventListener(MouseEvent.MOUSE_DOWN, _startDrag);
			}
			catch(e:Error)
			{
				
			}
		}
		
		
		protected function _onWheel(e:MouseEvent):void
		{
			var delta:int = e.delta;
			handle.y = Math.min(Math.max(0, handle.y - delta), dummyArea.height-handle.height);
		}
		
		protected function _startDrag(e:MouseEvent):void
		{
			offset.x = -e.localX;
			offset.y = -e.localY;
			_dragged = true;
			this.addEventListener(MouseEvent.MOUSE_UP, _stopDrag);
//			Stage.sigMouseUp.add(_stopDrag);
			vector.y = handle.y;
			lastPosition.y = 0;
		}
		
		protected function _drag(e:Event):void
		{
			if(_dragged)
				handle.y = Math.min(Math.max(0, this.mouseY + offset.y), dummyArea.height-handle.height);
			
			var pos:Number = (handle.y) / (dummyArea.height - handle.height);
			this.dispatchEvent(new ScrollEvent(ScrollEvent.UPDATE, pos));
			
			/*
			vector.y = handle.y - lastPosition.y;
			lastPosition.y = handle.y;
			*/
		}
		
		protected function _stopDrag(e:MouseEvent):void
		{
//			this.removeEventListener(Event.ENTER_FRAME, _drag);
			_dragged = false;
			this.removeEventListener(MouseEvent.MOUSE_UP, _stopDrag);
//			Stage.sigMouseUp.remove(_stopDrag);
			
//			this.addEventListener(Event.ENTER_FRAME, _brake);
		}
		
		
		protected function _brake(e:Event):void
		{
			handle.y = Math.min(Math.max(0, handle.y + vector.y * .1), height-handle.height);
			var pos:Number = (handle.y) / (dummyArea.height - handle.height);
			this.dispatchEvent(new ScrollEvent(ScrollEvent.UPDATE, pos));
			vector.y *= .8;
			if(Math.abs(vector.y) < 1) this.removeEventListener(Event.ENTER_FRAME, _brake);
		}
		
		
		public function destroy():void
		{
			for each(var d:DisplayObject in this)
			{
				this.removeChild(d);
			}
			
			this.unbind();
			this.removeEventListener(Event.ADDED_TO_STAGE, _onAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, _onRemoved);
		}
	}
}