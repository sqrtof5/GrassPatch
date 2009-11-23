package {

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	
	[ SWF (width=800, height=600, backgroundColor=0x111C11, frameRate=31)]
		
	public class GrassPatch extends Sprite {
		
		private var container:MovieClip;
		private var strands:Array = [];
		
		private var _prev_mousex:Number;
		private var _prev_mousey:Number;
		
		private var _FX_ON:Boolean = true;
		
		function GrassPatch() {
			
			stage.scaleMode = "noScale";

			container = new MovieClip();
			
			container.x = 400;
			container.y = 400;
			container.z = 700;
			
			container.rotationX = 45;

			addChild(container);

			createStrands();
			setInteraction();
			
		}
		
		private function createStrands():void {

			var w:uint = 850;
			var h:uint = 850;

			var numStrands:uint = 90;

			for (var i:uint=0; i<numStrands; i++) {

				var _strand:Strand = new Strand(-10 + Math.random()*20);
				_strand.rotationY = -60 + Math.random()*120;
				_strand.y = -Math.random()*20;
				_strand.rotationZ = -6 + Math.random()*12;
				_strand.x = -w/2 + Math.round(Math.random()*w);
				_strand.z = -h/2 + Math.round(Math.random()*h);

				container.addChild(_strand);
				strands.push(_strand);

			}

			reorder();

		}
		
		private function setInteraction():void {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseEvents);
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseEvents);
		}
		
		private function handleMouseEvents(evt:MouseEvent):void {
			
			switch (evt.type) {
				
				case MouseEvent.MOUSE_MOVE:
					container.rotationX += (mouseY - _prev_mousey)*.8;
					container.rotationY -= (mouseX - _prev_mousex)*.8;
					//if (stage.quality != "low") stage.quality = "low";
					_prev_mousex = mouseX;
					_prev_mousey = mouseY;
					reorder();
					break;
				
				case MouseEvent.MOUSE_DOWN:
					_prev_mousex = mouseX;
					_prev_mousey = mouseY;
					stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseEvents);
					break;
				
				case MouseEvent.MOUSE_UP:
					//stage.quality = "high";
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseEvents);
					break;
			}
			
		}
		
		private function reorder():void {
			
			for (var i:uint=0; i<strands.length; i++) {

				try {
					strands[i].reorder();
				} catch(e:*) {
					trace(e.message);
				}
				
			}
			
			for (i=0; i<strands.length; i++) {
				strands[i].tmpz = strands[i].transform.getRelativeMatrix3D(root).position.z;
				container.removeChild(strands[i]);
			}
			
			strands.sortOn("tmpz", Array.NUMERIC | Array.DESCENDING);
			
			for (i=0; i<strands.length; i++) {
				
				container.addChild(strands[i]);
				
				if (_FX_ON) {
					var zindex:Number = .2 + (i/strands.length);
					//strands[i].blendMode = (zindex < .35)? "multiply" : "normal";
					(zindex < .7)? strands[i].filters = [new BlurFilter(10 - (10*zindex), 10 - (10*zindex), 1)] : strands[i].filters = [];
					strands[i].alpha = (zindex < .55)? zindex*2 : 1;
				}
				
			}

		}
	
	}

}