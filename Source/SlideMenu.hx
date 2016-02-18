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
	slideMenu = new SlideMenu(textFormat, itemWidth, itemHeight);
	slideMenu.construct(["item1", "item2", "item3"], direction);
	slideMenu.open();
	slideMenu.menuFuncs[0]=function(){
		slideMenu.close();
	}
	addChild(slideMenu);

	~

	if(key.up) slideMenu.selectPrev()
	else if(key.down) slideMenu.selectNext()
	else if(key.enter) slideMenu.execItem();
*/

class SlideMenu extends Sprite implements SelectableMenu{
	private var items:Array<String>;
	private var menuItems:Array<Sprite>;
	public var menuFuncs:Array<Void -> Void>;
	private var cursor:Shape;
	public var selected:Int = 0;
	public var direction:Int = 0;	/* 0:右 1:上 2:左 3:下 */
	private var textFormat:TextFormat;
	public var pushing:Int = 0;	/* 始点からずらす数 */
	private var sizeW:Float = 0;
	private var sizeH:Float = 0;

	private var canMove=true;

	public function new(fmt:TextFormat, _sizeW:Float, _sizeH:Float){
		super();
		this.visible=false;
		textFormat=fmt;
		sizeW=_sizeW;
		sizeH=_sizeH;
		canMove=false;
	}

	public function construct(_items:Array<String>, _direction:Int){
		menuItems=new Array<Sprite>();
		menuFuncs=new Array<Void -> Void>();
		direction = _direction;
		items=_items;
		this.removeChildren();

		for(i in 0...items.length){
			menuItems[i] = new Sprite();

			/* メニューアイテムスタイリング */
			var g = menuItems[i].graphics;
			/*
			g.beginFill(0xf0f0f0, 0.75);
			g.drawRect(0, 0, sizeW, sizeH);
			g.endFill();
			g.beginFill(0xffffff, 1);
			g.drawRect(8, 8, sizeW-16, sizeH-16);
			g.endFill();
			*/
			g.beginFill(0xffffff, 1);
			g.drawRect(0, 0, sizeW, sizeH);
			g.endFill();
			g.beginFill(0x101010, 1);
			g.drawRect(2, 2, sizeW-4, sizeH-4);
			g.endFill();
			g.beginFill(0xffffff, 1);
			g.drawRect(6, 6, sizeW-12, sizeH-12);
			g.endFill();
			/* ------- */

			var label = new TextField();
			label.autoSize = TextFieldAutoSize.CENTER;
			label.selectable = false;
			label.defaultTextFormat = textFormat;
			label.text = items[i];
			label.width = sizeW;
			label.height = sizeH;
			label.y = sizeH/2 - textFormat.size/2;
			menuItems[i].addChild(label);

			this.addChild(menuItems[i]);

			menuFuncs[i]=function(){};
		}
		selected=0;
		cursor=new Shape();
		cursor.graphics.beginFill(0x000099, 0.5);
		cursor.graphics.drawRect(0, 0, sizeW, sizeH);
		cursor.graphics.endFill();
		this.addChild(cursor);
	}

	public function open(){
		selected=0;
		Actuate.tween(this, 0.25, {alpha: 1})
			.onComplete(function(){
				canMove=true;
			});
		switch(direction){
			case 0://left -> right
				for(i in 0...menuItems.length){
					Actuate.tween(menuItems[i], 1.0, {x: (i+pushing)*sizeW, y: 0});
				}
				cursor.x=(selected+pushing)*sizeW;
				cursor.y=0;
			case 1://bottom -> top
				for(i in 0...menuItems.length){
					Actuate.tween(menuItems[i], 1.0, {x: 0, y: -(i+pushing)*sizeH});
				}
				cursor.x=0;
				cursor.y=-(selected+pushing)*sizeH;
			case 2://right -> left
				for(i in 0...menuItems.length){
					Actuate.tween(menuItems[i], 1.0, {x: -(i+pushing)*sizeW, y: 0});
				}
				cursor.x=-(selected+pushing)*sizeH;
				cursor.y=0;
			case 3://top -> bottom
				for(i in 0...menuItems.length){
					Actuate.tween(menuItems[i], 1.0, {x: 0, y: (i+pushing)*sizeH});
				}
				cursor.x=0;
				cursor.y=(selected+pushing)*sizeH;
		}
		Actuate.tween(cursor, 1.0, {alpha: 1});
	}

	public function close(){
		Actuate.tween(cursor, 0.25, {alpha: 0}).autoVisible(false);

		/* メニューアイテムを束ねる */
		for(i in 0...menuItems.length){
			Actuate.tween(menuItems[i], 1.0, {x: 0, y: 0});
		}

		/* メニュー自体を隠す */
		Actuate.tween(this, 0.25, {alpha: 0}).autoVisible(false);

		canMove=false;
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

			/* カーソルが動いている間メニュー操作禁止 */
			canMove=false;

			Actuate.tween(cursor, 0.3,
				{
					x: menuItems[selected].x,
					y: menuItems[selected].y
				});

			/* 0.1秒後にメニューの操作を可能にする */
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