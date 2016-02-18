package;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.text.Font;
import openfl.text.FontStyle;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextField;
import openfl.text.TextFormat;

class BoxedLabel extends Sprite{
	private var label:TextField;

	public function new(w:Float, h:Float, fmt:TextFormat){
		super();
		var g=this.graphics;
		g.beginFill(0xffffff, 1);
		g.drawRect(0, 0, w, h);
		g.endFill();
		g.beginFill(0x101010, 1);
		g.drawRect(2, 2, w-4, h-4);
		g.endFill();
		g.beginFill(0xffffff, 1);
		g.drawRect(6, 6, w-12, h-12);
		g.endFill();

		label=new TextField();
		label.defaultTextFormat=fmt;
		label.selectable=false;
		label.autoSize=TextFieldAutoSize.LEFT;
		label.x=12;
		label.y=h/2 - fmt.size/2;

		addChild(label);
	}

	public function update(str:String){
		label.text=str;
	}
}