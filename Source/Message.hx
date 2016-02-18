package;

using unifill.Unifill;

import openfl.display.Sprite;
import openfl.text.Font;
import openfl.text.FontStyle;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.TextFieldAutoSize;
import motion.Actuate;

class Message extends Sprite{
	private var self=this;
	private var text:TextField;
	public var canPut:Bool = true;
	private var chars:Array<TextField>;
	private var tmpContent:String = "";
	private var blankSize:Float;
	public var speed:Float = 0.8;

	public var textFormat:TextFormat;
	public var innerHeight:Float = 0;
	public var currentWidth:Float = 0;
	public var maxWidth:Float = 0;

	public function new(_maxWidth:Float, fmt:TextFormat){
		super();
		
		text=new TextField();
		text.selectable=false;
		text.width=_maxWidth;
		text.height=600;
		text.multiline=true;
		text.defaultTextFormat=fmt;
		self.addChild(text);
		canPut=true;
		chars=new Array<TextField>();
		tmpContent="";

		{
			var bA=new TextField();
			bA.defaultTextFormat=fmt;
			bA.text="a b";
			var bB=new TextField();
			bB.defaultTextFormat=fmt;
			bB.text="ab";
			blankSize = bA.textWidth - bB.textWidth;
		}
		trace(blankSize);

		textFormat=fmt;
		innerHeight=0;
		currentWidth=0;
		maxWidth=_maxWidth;
	}

	public function checkCanPut(){
		if(!canPut){
			
			for(i in 0...chars.length){
				Actuate.stop(chars[i]);
				self.removeChild(chars[i]);
			}
			text.appendText(tmpContent);
			tmpContent="";
		}
	}

	public function lineBreak(){
		checkCanPut();
		text.appendText("\n");
		currentWidth=0;
		innerHeight+=textFormat.size;
	}

	public function put(str:String){
		checkCanPut();

		chars=new Array<TextField>();
		canPut=false;

		for(i in 0...str.uLength()){
			chars[i] = new TextField();
			chars[i].selectable = false;
			chars[i].defaultTextFormat = textFormat;
			chars[i].text = str.uCharAt(i);

			if(chars[i].text==	" ")currentWidth+=blankSize;

			if(currentWidth+chars[i].textWidth > maxWidth){
				currentWidth=0;
				innerHeight+=chars[i].textHeight;
				tmpContent+="\n";
			}
			tmpContent+=chars[i].text;

			chars[i].x = currentWidth;
			currentWidth+=chars[i].textWidth;
			chars[i].y = innerHeight;
			chars[i].alpha = 0;
			chars[i].scaleX = chars[i].scaleY = 0.5;

			if(i!=str.uLength()-1){
				Actuate.tween(chars[i], speed,
					{
						scaleX: 1,
						scaleY: 1,
						alpha: 1
					})
					.delay(i*(speed/4));
			}else{	//最後の文字の表示が完了したら全体を固定化
				Actuate.tween(chars[i], speed,
					{
						scaleX: 1,
						scaleY: 1,
						alpha: 1
					})
					.delay(i*(speed/4))
					.onComplete(function(){
						text.appendText(tmpContent);
						tmpContent="";
						for(i in 0...chars.length){
							self.removeChild(chars[i]);
						}
						canPut=true;
					});
			}

			self.addChild(chars[i]);
		}
	}
}