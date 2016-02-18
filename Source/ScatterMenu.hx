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

typedef ScatterMenuItem = {
	var x: Float;
	var y: Float;
}

class ScatterMenu extends Sprite implements SelectableMenu{
	private var items:Array<ScatterMenuItem>;
	private var menuItems:Array<Shape>;
	public var menuFuncs:Array<Void -> Void>;
	private var cursor:Shape;
	public var selected:Int = 0;
	private var textFormat:TextFormat;

	private var canMove=true;

	public function new(){
		super();
		canMove=true;
	}

	public function construct(_items:Array<ScatterMenuItem>){
		menuItems=new Array<Shape>();
		menuFuncs=new Array<Void -> Void>();
		items=_items;
		this.removeChildren();
		for(i in 0...items.length){
			menuItems[i] = new Shape();
			var g=menuItems[i].graphics;
			g.beginFill(0xff0000, 1);
			g.drawCircle(0, 0, 20);
			g.endFill();
			g.beginFill(0xffffff, 1);
			g.drawCircle(0, 0, 16);
			g.endFill();
			g.beginFill(0xff0000, 1);
			g.drawCircle(0, 0, 12);
			g.endFill();
			menuItems[i].x=items[i].x;
			menuItems[i].y=items[i].y;
			this.addChild(menuItems[i]);

			menuFuncs[i]=function(){};
		}
		selected=0;
		cursor=new Shape();
		cursor.graphics.beginFill(0x00ff00, 0.5);
		cursor.graphics.drawCircle(0, 0, 48);
		cursor.graphics.endFill();
		cursor.x=menuItems[0].x;
		cursor.y=menuItems[0].y;
		this.addChild(cursor);
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
					x: menuItems[selected].x,
					y: menuItems[selected].y
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