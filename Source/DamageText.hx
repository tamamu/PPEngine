package;

import openfl.display.Sprite;
import openfl.text.Font;
import openfl.text.FontStyle;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import motion.Actuate;

/*	Usage
	var damage=new DamageText();
	addChild(damage);

	~

	damage.put(calculateDamage().toString, textFormat);
*/
class DamageText extends Sprite{
	private var self=this;

	public function new(){
		super();
	}

	public function put(str:String, fmt:TextFormat){
		self.removeChildren();
		Actuate.apply(self, {alpha: 1});
		var chars = new Array<TextField>();
		for(i in 0...str.length){
			chars[i] = new TextField();
			chars[i].selectable = false;
			chars[i].defaultTextFormat = fmt;
			chars[i].text = str.charAt(i);
			chars[i].x = 0;
			chars[i].y = -fmt.size*0.75;
			chars[i].alpha = 0;
			Actuate.tween(chars[i], 0.3, {x: fmt.size*0.5 * i, y: 0, alpha: 1}).delay(i*0.07);
			self.addChild(chars[i]);
		}
		Actuate.tween(self, 0.4, {alpha: 0})
			.delay(str.length*0.1+0.5).autoVisible(false);
	}
}