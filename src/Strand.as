package {

	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	public class Strand extends MovieClip {

		private var _prev_mousex:Number;
		private var _prev_mousey:Number;
		private var _segments:Array = [];
		
		public var tmpz:Number;
		
		private var curv_inc:Number;
		private var num_seg:Number;
		
		[ Embed (source="_assets/text_01.png") ]
		public var Segment1:Class;

		[ Embed (source="_assets/text_02.png") ]
		public var Segment2:Class;

		[ Embed (source="_assets/text_03.png") ]
		public var Segment3:Class;

		[ Embed (source="_assets/text_04.png") ]
		public var Segment4:Class;

		[ Embed (source="_assets/text_05.png") ]
		public var Segment5:Class;
		
		
		function Strand(curv_inc:Number, num_seg:Number = 5) {
			
			this.curv_inc = curv_inc;
			this.num_seg = num_seg;
			createSegments();
			
		}
		
		private function createSegments():void {
			
			var count:uint = 0;
			
			for (var i:uint=0; i<num_seg; i++) {
				
				count++;
				
				var _seg_gfx:Bitmap;
				var _seg:MovieClip = new MovieClip();
				
				switch (i) { // ouch this is sooo ugly
					case 0:
						_seg_gfx = new Segment1() as Bitmap;
						break;
					case 1:
						_seg_gfx = new Segment2() as Bitmap;
						break;
					case 2:
						_seg_gfx = new Segment3() as Bitmap;
						break;
					case 3:
						_seg_gfx = new Segment4() as Bitmap;
						break;
					case 4:
						_seg_gfx = new Segment5() as Bitmap;
						break;
				}
				
				var seg_length:Number = _seg_gfx.height;
				
				_seg_gfx.smoothing = true;
				_seg.addChild(_seg_gfx);
				_seg_gfx.x = -_seg_gfx.width*.5;
				_seg_gfx.y = -_seg_gfx.height*.5;
				
				if (i != 0) {
					
					_seg.y = -i * seg_length;
					_seg.z = 0;

					//get top edge of previous segment
					var theta:Number = ((_segments[i-1].rotationX*Math.PI)/180) - Math.PI/2;
					var top_edge_y:Number = _segments[i-1].y + Math.sin(theta)*(seg_length*.5);
					var top_edge_z:Number = _segments[i-1].z - Math.cos(theta)*(seg_length*.5);

					//get bottom edge of current segment
					var omega:Number = ((-count*curv_inc*Math.PI)/180) - Math.PI/2;
					var bottom_edge_y:Number = _seg.y + Math.sin(omega+Math.PI)*(seg_length*.5);
					var bottom_edge_z:Number = _seg.z - Math.cos(omega+Math.PI)*(seg_length*.5);

					//apply rotation, translate plane to align edges
					_seg.rotationX = -count*curv_inc;
					_seg.y += top_edge_y - bottom_edge_y;
					_seg.z += top_edge_z - bottom_edge_z;	

				}
				
				_segments.push(_seg);
				addChild(_seg);
				
			}
			
		}
		
		public function reorder():void {
		
			try {
				for (var i:uint=0; i<_segments.length; i++) {
					_segments[i].tmpz = _segments[i].transform.getRelativeMatrix3D(root).position.z;
					removeChild(_segments[i]);
				}
			
				_segments.sortOn("tmpz", Array.NUMERIC | Array.DESCENDING);
			
				for (i=0; i<_segments.length; i++) {
					addChild(_segments[i]);
				}
			} catch(e:*) {
				//
			}
			
		}

	}

}