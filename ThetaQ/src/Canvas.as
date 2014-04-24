package  
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author umhr
	 */
	public class Canvas extends Sprite 
	{
        [Embed(source = "icon_plus_alt2.png")]
        private var plus:Class;
        [Embed(source = "icon_minus_alt2.png")]
        private var minus:Class;
        [Embed(source = "arrow_carrot-up_alt2.png")]
        private var up:Class;
        [Embed(source = "arrow_carrot-down_alt2.png")]
        private var down:Class;
        [Embed(source = "arrow_carrot-left_alt2.png")]
        private var left:Class;
        [Embed(source = "arrow_carrot-right_alt2.png")]
        private var right:Class;
        [Embed(source = "arrow_expand.png")]
        private var expand:Class;
        [Embed(source = "arrow_condense.png")]
        private var condense:Class;
        [Embed(source = "upload.png")]
        private var upload:Class;
		private var _earth:Earth;
		private var _downPos:Point = new Point();
		private var _buttonBase:Sprite = new Sprite();
		private var _expand:BasicButton;
		private var _fetchFile:FetchFile = new FetchFile();
		public function Canvas() 
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
			
			var loader:Loader = new Loader();
			var loaderInfo:LoaderInfo = loader.contentLoaderInfo;
			loaderInfo.addEventListener(Event.COMPLETE, loader_complete);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderInfo_ioError);
			loader.load(new URLRequest(Main.defaultImage));
			
		}
		
		private function loaderInfo_ioError(e:IOErrorEvent):void 
		{
			var loaderInfo:LoaderInfo = e.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, loader_complete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderInfo_ioError);
			placeHold();
		}
		
		private function loader_complete(e:Event):void 
		{
			var loaderInfo:LoaderInfo = e.target as LoaderInfo;
			if (loaderInfo.content.toString() == "[object Bitmap]") {
				var bitmapData:BitmapData = Bitmap(loaderInfo.content).bitmapData;
				setBitmapData(bitmapData);
			}else {
				placeHold();
			}
			loaderInfo.removeEventListener(Event.COMPLETE, loader_complete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderInfo_ioError);
		}
		
		private function placeHold():void {
			var bitmapData:BitmapData = new BitmapData(2048, 2048, false);
			bitmapData.draw(new Ichimatsu(2048, 2048));
			setBitmapData(bitmapData);
		}
		
		private function setBitmapData(bitmapData:BitmapData):void 
		{
			
			_earth = new Earth(bitmapData);
			addChild(_earth);
			//_earth.rX = _position.x = 0;
			_earth.rY = _position.y = -90;
			//_earth.zoom = _position.z = -550;
			
			addButtons();
			
			stage_resize(null);
		}
		
		private function addButtons():void {
			addChild(_buttonBase);
			new BasicButton(_buttonBase, 0, 0, "left", onButton, new left());
			new BasicButton(_buttonBase, 0, 50, "right", onButton, new right());
			new BasicButton(_buttonBase, 0, 100, "up", onButton, new up());
			new BasicButton(_buttonBase, 0, 150, "down", onButton, new down());
			new BasicButton(_buttonBase, 0, 200, "plus", onButton, new plus());
			new BasicButton(_buttonBase, 0, 250, "minus", onButton, new minus());
			new BasicButton(_buttonBase, 0, 300, "upload", onButton, new upload());
			_expand = new BasicButton(_buttonBase, 0, 350, "expand", onButton, new expand(), new condense());
			
			_fetchFile.addEventListener(Event.COMPLETE, fetchFile_complete);
			_earth.addEventListener(MouseEvent.MOUSE_WHEEL, stage_mouseWheel);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMove);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDown);
			stage.addEventListener(Event.ENTER_FRAME, stage_enterFrame);
			stage.addEventListener(Event.RESIZE, stage_resize);
			
		}
		
		private var _isAutoRotation:Boolean = true;
		private function stage_mouseDown(event:MouseEvent):void 
		{
			_isAutoRotation = false;
		}
		
		private function fetchFile_complete(e:Event):void 
		{
			if (_fetchFile.content == "[object Bitmap]") {
				var bitmap:Bitmap = _fetchFile.content as Bitmap;
				_earth.add(bitmap.bitmapData);
			}
		}
		
		private function stage_resize(e:Event):void 
		{
			_earth.resize();
			_buttonBase.x = stage.stageWidth - _buttonBase.width-16;
			_buttonBase.y = stage.stageHeight - _buttonBase.height-16;
		}
		
		private var _position:Vector3D = new Vector3D(0, -90, -550);
		private var _count:int = -100;
		private function stage_enterFrame(event:Event):void 
		{
			if (_isAutoRotation) {
				_position.y +=0.1;
				_earth.rY = _position.y;
				_earth.render();
				return;
			}
			
			if (_count > 0) { return };
			_count++;
			_earth.rX = _position.x * 0.1 + _earth.rX * 0.9;
			_earth.rY = _position.y * 0.1 + _earth.rY * 0.9;
			_earth.zoom = _position.z * 0.1 + _earth.zoom * 0.9;
			_earth.render();
		}
		
		private function stage_mouseWheel(event:MouseEvent):void 
		{
			_position.z = Math.max( -1400, Math.min(400, _earth.zoom + event.delta * 50));
		}
		
		private function onButton(event:MouseEvent):void 
		{
			var pushButton:BasicButton = event.target as BasicButton;
			var label:String = pushButton.label;
			if (label == "plus") {
				_position.z = Math.max( -1400, Math.min(400, _earth.zoom + 100));
			}else if (label == "minus") {
				_position.z = Math.max( -1400, Math.min(400, _earth.zoom - 100));
			}else if (label == "right") {
				_position.y = _earth.rY - 30;
			}else if (label == "left") {
				_position.y = _earth.rY + 30;
			}else if (label == "up") {
				_position.x = _earth.rX + 30;
			}else if (label == "down") {
				_position.x = _earth.rX - 30;
			}else if (label == "Home") {
				_position.x = 0;
				_position.y = 0;
				_position.z = -550;
			}else if (label == "upload") {
				_fetchFile.start([new FileFilter("Images(*.jpg;*.gif;*.png)", "*.jpg;*.gif;*.png")]);
			}else if (label == "expand") {
				if(stage.displayState == "normal"){
					stage.displayState = "fullScreen";
					_expand.isToggled = true;
				}else{
					stage.displayState = "normal";
					_expand.isToggled = false;
				}
			}
			_count = -100;
		}
		
		
		private function stage_mouseMove(event:MouseEvent):void 
		{
			if (event.buttonDown) {
				_count = -100;
				_position.x += (mouseY - _downPos.y) * 0.3;
				_position.y += (mouseX - _downPos.x) * 0.3;
			}
			_downPos.x = mouseX;
			_downPos.y = mouseY;
			
		}
	}
	
}

