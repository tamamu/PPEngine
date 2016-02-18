package;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.Graphics;
import motion.Actuate;

class Graph extends Sprite{
	private var graph:Shape;
	public var deg:Float;
	private var vertical:Bool;
	public function new(width:Float, height:Float, color:UInt, ?_vertical:Bool = false){
		super();
		deg=0.0;
		vertical=_vertical;
		graph=new Shape();
		this.graphics.beginFill(color, 0.2);
		this.graphics.drawRect(0, 0, width, height);
		this.graphics.endFill();
		graph.graphics.beginFill(color, 1.0);
		graph.graphics.drawRect(4, 4, width-8, height-8);
		graph.graphics.endFill();
		if(vertical){
			graph.scaleY=0;
		}else{
			graph.scaleX=0;
		}
		addChild(graph);
	}
	public function update(_deg:Float){
		if(vertical){
			Actuate.tween(graph, 1.0, {scaleY: _deg});
		}else{
			Actuate.tween(graph, 1.0, {scaleX: _deg});
		}
		deg=_deg;
	}
}