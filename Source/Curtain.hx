package;

import openfl.display.Shape;
import openfl.display.GradientType;

using CurtainType;

class Curtain extends Shape{
	public function new(width:Float, height:Float, type:CurtainType, color:UInt){
		super();
		var g=this.graphics;
		switch (type) {
			case FILL:
				g.beginFill(color, 1);
				g.drawRect(0, 0, width, height);
				g.endFill();
			case UP:
				g.beginGradientFill(GradientType.LINEAR, [color], [1, 0], [1, 0]);
				g.drawRect(0, 0, width, height);
				g.endFill();
			case DOWN:

		}

	}
}