package  
{
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author umhr
	 */
	public class Shield extends Sprite 
	{
		private var _shape:Shape = new Shape();
		public function Shield() 
		{
			init();
		}
		private function init():void 
		{
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}

		private function onInit(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			// entry point
			
			draw();
		}
		private function draw():void {
			graphics.clear();
			graphics.beginFill(0x000000, 0.5);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			
			_shape.graphics.clear();
			_shape.graphics.beginFill(0xFFFFFF, 1);
			_shape.graphics.drawCircle(0, 0, 90);
			_shape.graphics.drawCircle(0, 0, 80);
			for (var i:int = 0; i < 4; i++) 
			{
				if (i == 0) {
					_shape.graphics.moveTo(Math.cos(2 * Math.PI * (i / 3))*50, Math.sin(2 * Math.PI * (i / 3))*50);
				}else {
					_shape.graphics.lineTo(Math.cos(2 * Math.PI * (i / 3))*50, Math.sin(2 * Math.PI * (i / 3))*50);
				}
			}
			_shape.graphics.endFill();
			_shape.x = stage.stageWidth * 0.5;
			_shape.y = stage.stageHeight * 0.5;
			addChild(_shape);
		}
	}
	
}