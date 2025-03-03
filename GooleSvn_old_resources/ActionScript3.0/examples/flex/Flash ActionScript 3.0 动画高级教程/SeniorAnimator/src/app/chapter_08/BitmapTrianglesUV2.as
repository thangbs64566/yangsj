package app.chapter_08
{
	import code.SpriteBase;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	
	/**
	 * 说明：BitmapTrianglesUV2
	 * @author victor
	 * 2012-9-2 上午12:38:39
	 */
	
	public class BitmapTrianglesUV2 extends SpriteBase
	{
		
		////////////////// vars /////////////////////////////////
		
		[Embed(source="assets/chapter_8/ting.jpg")]
		private var ImageClass:Class;
		
		private var handle0:Sprite;
		private var handle1:Sprite;
		private var handle2:Sprite;
		private var handle3:Sprite;
		private var vertices:Vector.<Number> = new Vector.<Number>();
		private var uvtData:Vector.<Number> = new Vector.<Number>();
		private var indices:Vector.<int> = new Vector.<int>();
		private var bitmap:Bitmap;
		
		public function BitmapTrianglesUV2()
		{
			super();
		}
		
		override protected function initialization():void
		{
			handle0 = makeHandle(100,100);
			handle1 = makeHandle(200,100);
			handle2 = makeHandle(200,200);
			handle3 = makeHandle(100,200);
			
			uvtData.push(0,0);
			uvtData.push(1,0);
			uvtData.push(1,1);
			uvtData.push(0,1);
			
			indices.push(0,1,2);
			indices.push(2,3,0);
			
			bitmap = new ImageClass() as Bitmap;
			draw();
			
		}
		
		private function makeHandle(xpos:Number, ypos:Number):Sprite
		{
			var handle:Sprite = new Sprite();
			handle.graphics.beginFill(0);
			handle.graphics.drawCircle(0,0,5);
			handle.graphics.endFill();
			handle.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			handle.x = xpos;
			handle.y = ypos;
			addChild(handle);
			return handle;
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			event.target.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			draw();
		}
		
		private function draw():void
		{
			vertices[0] = handle0.x;
			vertices[1] = handle0.y;
			vertices[2] = handle1.x;
			vertices[3] = handle1.y;
			vertices[4] = handle2.x;
			vertices[5] = handle2.y;
			vertices[6] = handle3.x;
			vertices[7] = handle3.y;
			
			graphics.clear();
			graphics.beginBitmapFill(bitmap.bitmapData);
			graphics.drawTriangles(vertices, indices, uvtData);
			graphics.endFill();
		}
		
		////////////////// static /////////////////////////////////
		
		
		
		////////////////// public /////////////////////////////////
		
		
		
		////////////////// private ////////////////////////////////
		
		
		
		////////////////// events//////////////////////////////////
		
		
		
	}
}