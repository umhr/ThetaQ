package
{
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	import away3d.textures.Texture2DBase;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import primitives.HemiSphereGeometry;

	public class Earth extends Sprite
	{
		private var view3d:View3D;
		private var mesh:Mesh;
		private var _texture:BitmapData;
		public function Earth(texture:BitmapData):void
		{
			_texture = texture;
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
			
			view3d = new View3D();
			addChild(view3d);
			
			add(_texture);
			view3d.camera.z = -550;
			
		}
		
		public function add(bitmapData:BitmapData):void {
			var targetSize:int = 2;
			while (targetSize < Math.max(bitmapData.width,bitmapData.height)) 
			{
				targetSize += targetSize;
			}
			targetSize = Math.min(targetSize, 2048);
			
			var texture:BitmapData = new BitmapData(targetSize, targetSize, false, 0x0);
			texture.drawWithQuality(bitmapData, new Matrix(targetSize / bitmapData.width, 0, 0, targetSize / bitmapData.height), null, null, null, true, StageQuality.HIGH_16X16);
			
			var ts:Texture2DBase = new BitmapTexture(texture);
			var material:TextureMaterial = new TextureMaterial(ts);
			var geometry:HemiSphereGeometry = new HemiSphereGeometry(450, 64, 64);
			if (mesh) {
				mesh.material = null;
				mesh.disposeAsset();
			}
			mesh = new Mesh(geometry, material);
			while (view3d.scene.numChildren > 0) {
				view3d.scene.removeChildAt(0);
			}
			view3d.scene.addChild(mesh);
			resetPosition(0, 0, -550);
		}
		
		
		private var _rX:Number = 0;
		private var _rY:Number = 0;
		
		public function resize():void
		{
			view3d.width = stage.stageWidth;
			view3d.height = stage.stageHeight;
		}

		public function render():void {
			view3d.render();
		}
		public function get zoom():Number {
			return view3d.camera.z;
		}
		public function set zoom(value:Number):void {
			view3d.camera.z = value;
		}
		public function get rX():Number 
		{
			return _rX;
		}
		public function set rX(value:Number):void 
		{
			var matrix3D:Matrix3D = mesh.transform;
			matrix3D.appendRotation(value-_rX, new Vector3D(1, 0, 0, 0));
			mesh.transform = matrix3D;
			_rX = value;
			//trace(_rX, matrix3D.decompose()[1].x/Math.PI);
		}
		public function get rY():Number 
		{
			return _rY;
		}
		public function set rY(value:Number):void 
		{
			var matrix3D:Matrix3D = mesh.transform;
			//matrix3D.appendRotation(value-_rY, new Vector3D(0, 1, 0, 0));
			var rad: Number = _rX * Math.PI / 180;
			matrix3D.appendRotation(value-_rY, new Vector3D(0, Math.cos(rad), Math.sin(rad), 0));
			
			mesh.transform = matrix3D;
			_rY = value;
		}
		
		public function resetPosition(x: Number, y: Number, z: Number):void{
			_rX = x;
			_rY = y;
			view3d.camera.z = z;
		}
	}
}