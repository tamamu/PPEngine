package;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.text.Font;
import openfl.text.FontStyle;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import motion.Actuate;

/*	Usage
	var menu = new Menu(textFormat);
	menu.construct(["item1", "item2", "item3"]);
	menu.menuFuncs[0]=function(){
		//Action of menuItem[0]
	}
	addChild(menu);

	~

	if(key.up) menu.selectPrev()
	else if(key.down) menu.selectNext()
	else if(key.enter) menu.execItem();
*/

class TextMenu extends Sprite implements SelectableMenu{
	private var items:Array<String>;
	private var menuItems:Array<TextField>;
	public var menuFuncs:Array<Void -> Void>;
	private var cursor:Shape;
	public var selected:Int = 0;
	private var textFormat:TextFormat;

	private var canMove=true;

	public function new(fmt:TextFormat){
		super();
		textFormat=fmt;
		canMove=true;
	}

	public function construct(_items:Array<String>){
		menuItems=new Array<TextField>();
		menuFuncs=new Array<Void -> Void>();
		items=_items;
		this.removeChildren();
		for(i in 0...items.length){
			menuItems[i] = new TextField();
			menuItems[i].autoSize = TextFieldAutoSize.LEFT;
			menuItems[i].selectable = false;
			menuItems[i].defaultTextFormat = textFormat;
			menuItems[i].text = items[i];
			menuItems[i].y = textFormat.size*i;
			this.addChild(menuItems[i]);

			menuFuncs[i]=function(){};
		}
		selected=0;
		cursor=new Shape();
		cursor.graphics.beginFill(0xffffff, 0.5);
		cursor.graphics.drawRect(0, 0, textFormat.size, textFormat.size);
		cursor.graphics.endFill();
		cursor.scaleX=menuItems[0].textWidth/textFormat.size;
		this.addChild(cursor);
	}

	public function blink(){
		Actuate.tween(cursor, 0.1, {alpha: 0.1}).repeat().reflect();
	}

	public function selectItem(idx:Int){
		if(canMove){
			if(idx<0){
				selected=items.length-1;
			}else if(idx>=items.length){
				selected=0;
			}else{
				selected=idx;
			}
			canMove=false;
			Actuate.tween(cursor, 0.3,
				{
					y: textFormat.size*selected,
					scaleX: menuItems[selected].textWidth/textFormat.size
				});
			Actuate.timer(0.1).onComplete(function(){
				canMove=true;
			});
			return true;
		}else{
			return false;
		}
	}

	public function stop(){
		canMove=false;
	}

	/* メニューの操作が可能な場合はtrueを返す */
	public function execItem(){
		if(canMove==true){
			menuFuncs[selected]();
			return true;
		}else{
			return false;
		}
	}

	public function selectPrev(){
		return selectItem(selected-1);
	}

	public function selectNext(){
		return selectItem(selected+1);
	}
}