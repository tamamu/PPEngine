package;


import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.text.Font;
import openfl.text.FontStyle;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.TextFieldAutoSize;
import openfl.Assets;

import openfl.media.Sound;
import openfl.media.SoundChannel;

import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TimerEvent;
import openfl.utils.Timer;

import motion.Actuate;

import gss.Interpreter;
using gss.Command;

enum GameState{
	Test;
	Title;
	SelectAction;
	SelectLocation;
	Talking(id:Int);
}

class Main extends Sprite {

	public var gameState:GameState = Title;
	public var fader:Curtain;

	public var key:KeyState;
	public var updateTimer:Timer;

	public var isPause = false;

	public var leftKeyFunc:Void -> Void;
	public var rightKeyFunc:Void -> Void;
	public var enterKeyFunc:Void -> Void;
	public var escKeyFunc:Void -> Void;
	public var enterKeyUpFunc:Void -> Void;

	public var playerData={maxlp: 100, lp: 100, maxmp: 10, mp: 5};

	/* UI Text */
	public var gameFont:Font;
	public var damageFormat:TextFormat;
	public var menuFormat:TextFormat;
	public var messageFormat:TextFormat;

	public var pmFormat:TextFormat;
	/* ------- */

	/* Sound */
	public var bgm:MusicManager;
	public var selectSound:Sound;
	public var decideSound:Sound;
	public var cancelSound:Sound;
	public var downSound:Sound;
	public var upSound:Sound;
	/* ------- */

	/* menu description */
	public var menuDesc:BoxedLabel;
	public var currentMenuNum:Int = 0;
	public var descText:Array<Array<String>>;
	/* ------- */

	/* data text */
	public var lifeLabel:BoxedLabel;
	public var motivLabel:BoxedLabel;
	public var dateLabel:BoxedLabel;
	public var annotLabel:BoxedLabel;
	/* ------- */

	/* Parameter Graph */
	public var lifeGraph:Graph;
	public var motivGraph:Graph;
	/* ------- */

	public var currentMenu:SelectableMenu;
	public var slideMenu:SlideMenu;
	public var slideMenuA:SlideMenu;
	public var slideMenuB:SlideMenu;
	public var slideMenuC:SlideMenu;
	public var slideMenuD:SlideMenu;
	public var SlideMenuE:SlideMenu;

	public var mapMenu:ScatterMenu;

	public var battleMenu:TextMenu;

	public var message:Message;

	public var damage:DamageText;
	
	public function new () {
		super ();

		loadSound();

		key=new KeyState();
		updateTimer=new Timer(60, 0);
		updateTimer.start();

		fader = new Curtain(1024, 768, CurtainType.FILL, 0x000000);

		setTextFormat();

		leftKeyFunc=rightKeyFunc=enterKeyFunc=escKeyFunc=function(){};

		changeState(SelectAction);

		/*
		damage=new DamageText();
		damage.x=40;
		damage.y=100;
		damage.put("123456", damageFormat);
		addChild(damage);

		message=new Message(600.0, messageFormat);
		message.x=300;
		message.y=140;
		addChild(message);

		slideMenuA = new SlideMenu(menuFormat, 64, 32);
		slideMenuA.construct([
			"A-1",
			"A-2",
			"A-3"
			], 1);
		slideMenuA.x=100;
		slideMenuA.y=300;
		slideMenuA.pushing=1;
		addChild(slideMenuA);

		slideMenu = new SlideMenu(menuFormat, 64, 32);
		slideMenu.construct([
			"A",
			"B",
			"C"
			], 0);
		slideMenu.x=slideMenuA.x;
		slideMenu.y=slideMenuA.y;
		slideMenu.open();
		addChild(slideMenu);

		battleMenu = new TextMenu(menuFormat);
		battleMenu.construct([
			"ダメージっぽい表示をする",
			"吾輩は猫であるの冒頭を表示する",
			"走れメロスの冒頭を表示する",
			"何もしない選択肢",
			"ネタ切れだ",
			"画面は開発中のものらしい"
			]);
		battleMenu.x=100;
		battleMenu.y=500;
		addChild(battleMenu);

		*/

		stage.addEventListener(KeyboardEvent.KEY_DOWN, key.setDownKeyCodes);
		stage.addEventListener(KeyboardEvent.KEY_UP, key.setUpKeyCodes);
		stage.addEventListener(Event.ENTER_FRAME, mainPLoop);
	}

	public function loadSound(){
		bgm = new MusicManager();
		bgm.addMusic("assets/bgm03.ogg");
		bgm.addMusic("assets/bgm22.ogg");
		selectSound = Assets.getSound("assets/sys13.wav");
		decideSound = Assets.getSound("assets/sys24.wav");
		cancelSound = Assets.getSound("assets/sys07.wav");
		downSound = Assets.getSound("assets/point33.wav");
		upSound = Assets.getSound("assets/point17.wav");
	}

	public function constructPData(){
		dateLabel=new BoxedLabel(220, 90, menuFormat);
		dateLabel.update("2月2週 1年目");
		dateLabel.x=20;
		dateLabel.y=20;
		addChild(dateLabel);

		lifeLabel=new BoxedLabel(440, 56, messageFormat);
		lifeLabel.update("体力");
		lifeLabel.x=540;
		lifeLabel.y=36;
		addChild(lifeLabel);
		lifeGraph=new Graph(320, 32, 0x3366ff);
		lifeGraph.update(playerData.lp/playerData.maxlp);
		lifeGraph.x=620;
		lifeGraph.y=48;
		addChild(lifeGraph);
		motivLabel=new BoxedLabel(240, 56, messageFormat);
		motivLabel.update("やる気");
		motivLabel.x=260;
		motivLabel.y=36;
		addChild(motivLabel);
		motivGraph=new Graph(120, 32, 0xff99cc);
		motivGraph.update(playerData.mp/playerData.maxmp);
		motivGraph.x=360;
		motivGraph.y=48;
		addChild(motivGraph);
	}

	public function lifeUp(deg:Int){
		playerData.lp+=deg;
		if(playerData.lp>playerData.maxlp)playerData.lp=playerData.maxlp;
		lifeGraph.update(playerData.lp/playerData.maxlp);
		upSound.play();
	}

	public function lifeDown(deg:Int){
		playerData.lp-=deg;
		if(playerData.lp<0)playerData.lp=0;
		lifeGraph.update(playerData.lp/playerData.maxlp);
		downSound.play();
	}

	public function constructPMenu(){
		bgm.play(1);
		addChild(new Bitmap(Assets.getBitmapData("assets/bg.png")));

		constructPData();

		menuDesc=new BoxedLabel(600, 64, messageFormat);
		menuDesc.update("メニューを選んでください");
		menuDesc.x=20;
		menuDesc.y=560;
		addChild(menuDesc);

		descText=[
			[
				"練習をします",
				"うろつきます",
				"回復します",
				"能力を強化します",
				"アイテムを使用します",
				"セーブなどを行います"
			],
			[
				"戻る",
				"ランニング",
				"ストレッチ",
				"グラウンド整備",
				"筋トレ",
				"素振り",
				"球みがき",
				"トスバッティング",
				"球ひろい",
				"ダッシュ",
				"練習見学",
				"練習手伝い",
				"総合練習"
			],
			[
				"戻る",
				"休んで体力を回復します",
				"病気を治療します"
			],
			[
				"戻る",
				"セーブしてゲームを中断します",
				"用語を調べます"
			]
		];

		var setBackMenuFunc=function(){
			escKeyFunc=function(){
				cancelSound.play();
				currentMenu.menuFuncs[0]();
			}
		}
		var setSelectFirstFunc=function(){
			escKeyFunc=function(){
				if(currentMenu.selectItem(0)){
					cancelSound.play();
				}
			}
		}

		slideMenu = new SlideMenu(menuFormat, 64, 64);
		slideMenu.construct([
			"練",
			"移",
			"回",
			"UP",
			"道",
			"設"
			], 0);
		slideMenu.open();
		slideMenu.menuFuncs[0]=function(){
			slideMenu.close();
			slideMenuA.open();
			currentMenu=slideMenuA;
			currentMenuNum=1;
			setBackMenuFunc();
		}
		slideMenu.menuFuncs[1]=function(){
			currentMenu.stop();
			changeState(SelectLocation);
		}
		slideMenu.menuFuncs[2]=function(){
			slideMenu.close();
			slideMenuB.open();
			currentMenu=slideMenuB;
			currentMenuNum=2;
			setBackMenuFunc();
		}
		slideMenu.menuFuncs[5]=function(){
			slideMenu.close();
			slideMenuC.open();
			currentMenu=slideMenuC;
			currentMenuNum=3;
			setBackMenuFunc();
		}
		slideMenu.x=20;
		slideMenu.y=640;

		slideMenuA = new SlideMenu(menuFormat, 64, 64);
		slideMenuA.construct([
			"←",
			"ラ",
			"伸",
			"整",
			"筋",
			"素",
			"磨",
			"ト",
			"拾",
			"走",
			"見",
			"補",
			"総"
			], 0);
		slideMenuA.menuFuncs[0]=function(){
			slideMenuA.close();
			slideMenu.visible=true;
			slideMenu.open();
			currentMenu=slideMenu;
			currentMenuNum=0;
			setSelectFirstFunc();
		}
		slideMenuA.x=slideMenu.x;
		slideMenuA.y=slideMenu.y;
		
		slideMenuB = new SlideMenu(menuFormat, 64, 64);
		slideMenuB.construct([
			"←",
			"休",
			"治"
			], 0);
		slideMenuB.menuFuncs[0]=function(){
			slideMenuB.close();
			slideMenu.open();
			currentMenu=slideMenu;
			currentMenuNum=0;
			setSelectFirstFunc();
		}
		slideMenuB.menuFuncs[1]=function(){
			lifeUp(30);
			slideMenuB.close();
			slideMenu.open();
			currentMenu=slideMenu;
			currentMenuNum=0;
			setSelectFirstFunc();
		}
		slideMenuB.x=slideMenu.x;
		slideMenuB.y=slideMenu.y;

		slideMenuC = new SlideMenu(menuFormat, 64, 64);
		slideMenuC.construct([
			"←",
			"保",
			"語"
			], 0);
		slideMenuC.menuFuncs[0]=function(){
			slideMenuC.close();
			slideMenu.open();
			currentMenu=slideMenu;
			currentMenuNum=0;
			setSelectFirstFunc();
		}
		slideMenuC.x=slideMenu.x;
		slideMenuC.y=slideMenu.y;

		addChild(slideMenuC);
		addChild(slideMenuB);
		addChild(slideMenuA);
		addChild(slideMenu);

		addChild(fader);

		currentMenu=slideMenu;

		leftKeyFunc=function(){
			if(currentMenu.selectPrev()){
				selectSound.play();
			}
		}
		rightKeyFunc=function(){
			if(currentMenu.selectNext()){
				selectSound.play();
			}
		}
		enterKeyFunc=function(){
			if(currentMenu.execItem()){
				decideSound.play();
			}
		}
		escKeyFunc=function(){
			if(currentMenu.selectItem(0)){
				cancelSound.play();
			}
		}
	}

	public function constructPMap(){
		addChild(new Bitmap(Assets.getBitmapData("assets/map.png")));

		annotLabel=new BoxedLabel(180, 50, messageFormat);
		annotLabel.update("Z:移動 X:戻る");
		annotLabel.x=0;
		annotLabel.y=768-50;
		addChild(annotLabel);

		menuDesc=new BoxedLabel(360, 56, menuFormat);
		menuDesc.update("行き先を選んでください");
		menuDesc.x=0;
		menuDesc.y=0;
		addChild(menuDesc);

		descText=[[
			"サン・ステファノ",
			"ロンドン・ブリッジ",
			"アメヨコ"
		]];

		mapMenu=new ScatterMenu();
		mapMenu.construct([
			{x: 240, y: 240},
			{x: 320, y: 600},
			{x: 720, y: 640}
			]);
		mapMenu.menuFuncs[0]=function(){
			mapMenu.stop();
			changeState(Talking(0));
		}
		mapMenu.menuFuncs[2]=function(){
			mapMenu.stop();
			changeState(Talking(2));
		}
		addChild(mapMenu);

		addChild(fader);

		currentMenu=mapMenu;

		leftKeyFunc=function(){
			if(currentMenu.selectPrev()){
				selectSound.play();
			}
		}
		rightKeyFunc=function(){
			if(currentMenu.selectNext()){
				selectSound.play();
			}
		}
		enterKeyFunc=function(){
			if(currentMenu.execItem()){
				decideSound.play();
			}
		}
		escKeyFunc=function(){
			cancelSound.play();
			escKeyFunc=function(){};
			changeState(SelectAction);
		}
	}

	public function constructPTalk(id:Int){
		var command=new Interpreter();
		isPause=true;
		bgm.play(0);
		switch (id) {
			case 0: addChild(new Bitmap(Assets.getBitmapData("assets/bg3.png")));
			case 2: addChild(new Bitmap(Assets.getBitmapData("assets/bg2.png")));
		}
		var mob=new Bitmap(Assets.getBitmapData("assets/mob.png"));
		mob.x=-mob.width;
		mob.y=768-mob.height;
		Actuate.tween(mob, 1.0, {x: 40});
		addChild(mob);

		constructPData();

		var mb=new Bitmap(Assets.getBitmapData("assets/mb.png"));
		mb.x=(1024-840)/2;
		mb.y=768-mb.height;
		addChild(mb);
		message=new Message(960, messageFormat);
		message.x=140;
		message.y=768-140;
		addChild(message);
		addChild(fader);
		switch (id) {
			case 0:
				command.load("Where am I?\\");
			case 2:
				command.load("……\nここアメ横じゃなくね？！\\");
				//message.put("体力が 30 下がった");
				//lifeDown(30);
		}
		leftKeyFunc=rightKeyFunc=escKeyFunc=function(){};
		enterKeyFunc=function(){
			if(message.canPut && !isPause){
				execCommand(command.next());
			}else{
				message.checkCanPut();
				isPause=true;
			}
		}
		execCommand(command.next());
	}

	public function execCommand(com:Command){
		switch (com) {
			case Put(msg):
				message.put(msg);
			case Pause:
				isPause=true;
			case BreakLine:
				message.lineBreak();
			case EOF:
				changeState(SelectAction);
		}
	}

	public function doTestCase(){

	}

	public function changeState(state:GameState){
		Actuate.tween(fader, 0.5, {alpha:1})
			.onComplete(function(){
				removeChildren();
				addChild(fader);
				switch (state) {
					case Test:
						doTestCase();
					case Title:

					case SelectAction:
						constructPMenu();
					case SelectLocation:
						constructPMap();
					case Talking(id):
						constructPTalk(id);
				}
				gameState=state;
				Actuate.tween(fader, 0.75, {alpha:0}).autoVisible(false);
			});
	}

	public function mainPLoop(event:Event){
		if(isPause){
			if(key.z.upTimer.running){
				isPause=false;
				key.z.upTimer.reset();
			}
		}
		if(key.left.pushed){
			leftKeyFunc();
		}else if(key.right.pushed){
			rightKeyFunc();
		}else if(key.z.pushed){
			enterKeyFunc();
		}else if(key.x.pushed){
			escKeyFunc();
		}
		switch(gameState){
			case Test:
			case Title:
			case SelectAction:
				menuDesc.update(descText[currentMenuNum][currentMenu.selected]);
			case SelectLocation:
				menuDesc.update(descText[0][currentMenu.selected]);
			case Talking(id):
		}
	}

	public function setTextFormat(){
		gameFont = Assets.getFont("assets/honoka.ttf");
		damageFormat = new TextFormat(gameFont.fontName, 48, 0x101010);
		damageFormat.bold=true;
		menuFormat = new TextFormat(gameFont.fontName, 32, 0x101010);
		messageFormat = new TextFormat(gameFont.fontName, 24, 0x101010);
		pmFormat = new TextFormat(gameFont.fontName, 12, 0x101010);
	}

	public function mainLoop(event:Event){
		if(key.up.pushed){
			battleMenu.selectPrev();
		}else if(key.down.pushed){
			battleMenu.selectNext();
		}else if(key.left.pushed){
			slideMenu.selectPrev();
			if(slideMenu.selected==0){
				slideMenuA.open();
			}else{
				slideMenuA.close();
			}
		}else if(key.right.pushed){
			slideMenu.selectNext();
			if(slideMenu.selected==0){
				slideMenuA.open();
			}else{
				slideMenuA.close();
			}
		}else if(key.enter.pushed){
			//battleMenu.blink();
			switch (battleMenu.selected) {
				case 0:damage.put(Std.string(Math.floor(Math.random()*100000+10)), damageFormat);
				case 1:message.put("吾輩 （ わがはい ） は猫である。名前はまだ無い。 どこで生れたかとんと 見当 （ けんとう ） がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。吾輩はここで始めて人間というものを見た。");
				case 2:message.lineBreak();message.put("メロスは激怒した。必ず、かの 邪智暴虐 （ じゃちぼうぎゃく ） の王を除かなければならぬと決意した。メロスには政治がわからぬ。メロスは、村の牧人である。笛を吹き、羊と遊んで暮して来た。けれども邪悪に対しては、人一倍に敏感であった。");
				case 3:
				case 4:
				default: 
			}
		}else if(key.esc.pushed){

		}
	}
}