package  
{
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author umhr
	 */
	public class BasicButton extends Sprite 
	{
		public var label:String;
		private var _bitmapList:Array/*Bitmap*/ = [];
		private var _handler:Function;
		private var _isToggled:Boolean;
		public function BasicButton(target:DisplayObjectContainer, x:Number, y:Number, label:String, handler:Function, bitmap:Bitmap, togleBitmap:Bitmap = null) 
		{
			target.addChild(this);
			this.x = x;
			this.y = y;
			this.label = label;
			_handler = handler;
			_bitmapList[0] = bitmap;
			if(togleBitmap){
				_bitmapList[1] = togleBitmap;
			}
			mouseUp(null);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			addEventListener(MouseEvent.ROLL_OUT, mouseUp);
			init();
		}
		
		private function mouseDown(e:MouseEvent):void 
		{
			var bitmap:Bitmap = currentBitmap();
			bitmap.bitmapData.colorTransform(bitmap.bitmapData.rect, new ColorTransform(0, 0, 0, 1));
			bitmap.filters = [new DropShadowFilter(0,0,0xFFFFFF,1,8,8)];
			_handler(e);
		}
		
		private function mouseUp(e:MouseEvent):void 
		{
			var bitmap:Bitmap = currentBitmap();
			bitmap.bitmapData.colorTransform(bitmap.bitmapData.rect, new ColorTransform(0, 0, 0, 1, 0xCC, 0xCC, 0xCC));
			bitmap.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
			
			while (this.numChildren > 0) {
				this.removeChildAt(0);
			}
			this.addChild(bitmap);
		}
		private function init():void 
		{
			
		}
		private function currentBitmap():Bitmap {
			if (_bitmapList.length == 1) {
				return _bitmapList[0];
			}else {
				return isToggled?_bitmapList[1]:_bitmapList[0];
			}
		}
		
		public function get isToggled():Boolean 
		{
			return _isToggled;
		}
		
		public function set isToggled(value:Boolean):void 
		{
			_isToggled = value;
			mouseUp(null);
		}
	}
	
}