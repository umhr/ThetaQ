package 
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author umhr
	 */
	public class Main extends Sprite 
	{
		static public var defaultImage:String = "default.jpg";
		private var _shield:Shield;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
			
			var parameters:Object = loaderInfo.parameters;
			if (parameters) {
				if (parameters.image) {
					defaultImage = parameters.image;
				}
				if (parameters.autoPlay == "false") {
					addShield();
					return;
				}
			}
			
			addCanvas();
			
			
		}
		
		private function addShield():void {
			_shield = new Shield();
			_shield.addEventListener(MouseEvent.MOUSE_DOWN, shield_mouseDown);
			addChild(_shield);
		}
		
		private function shield_mouseDown(event:MouseEvent):void 
		{
			_shield.removeEventListener(MouseEvent.MOUSE_DOWN, shield_mouseDown);
			addCanvas();
			removeChild(_shield);
		}
		
		private function addCanvas():void {
			addChild(new Canvas());
		}
		
	}
	
}