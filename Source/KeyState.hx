package;

import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import openfl.utils.Timer;

/*	Usage
	var key = new KeyState();
	stage.addEventListener(KeyboardEvent.KEY_DOWN, key.setDownKeyCodes);
	stage.addEventListener(KeyboardEvent.KEY_UP, key.setUpKeyCodes);

	~

	if(key.esc)trace("hoge");
*/

typedef State = {
	var pushed: Bool;
	var upTimer: Timer;
}

class KeyState {
	public var timing=10;

	public var right:State;
	public var left:State;
	public var up:State;
	public var down:State;
	public var enter:State;
	public var esc:State;
	public var z:State;
	public var x:State;

	public function new(){
		right= {pushed: false, upTimer:new Timer(timing)};
		left= {pushed: false, upTimer:new Timer(timing)};
		up= {pushed: false, upTimer:new Timer(timing)};
		down= {pushed: false, upTimer:new Timer(timing)};
		enter= {pushed: false, upTimer:new Timer(timing)};
		esc= {pushed: false, upTimer:new Timer(timing)};
		z= {pushed: false, upTimer:new Timer(timing)};
		x= {pushed: false, upTimer:new Timer(timing)};
	}

	public function setDownKeyCodes(e:KeyboardEvent){
		switch(e.keyCode){
			case Keyboard.DOWN:down.pushed=true;
			case Keyboard.UP:up.pushed=true;
			case Keyboard.LEFT:left.pushed=true;
			case Keyboard.RIGHT:right.pushed=true;
			case Keyboard.ENTER:enter.pushed=true;
			case Keyboard.ESCAPE:esc.pushed=true;
			case Keyboard.Z:z.pushed=true;
			case Keyboard.X:x.pushed=true;
		}
	}

	public function setUpKeyCodes(e:KeyboardEvent){
		switch(e.keyCode){
			case Keyboard.DOWN:
				down.pushed=false;
				down.upTimer.start();
			case Keyboard.UP:
				up.pushed=false;
				up.upTimer.start();
			case Keyboard.LEFT:
				left.pushed=false;
				left.upTimer.start();
			case Keyboard.RIGHT:
				right.pushed=false;
				right.upTimer.start();
			case Keyboard.ENTER:
				enter.pushed=false;
				enter.upTimer.start();
			case Keyboard.ESCAPE:
				esc.pushed=false;
				esc.upTimer.start();
			case Keyboard.Z:
				z.pushed=false;
				z.upTimer.start();
			case Keyboard.X:
				x.pushed=false;
				x.upTimer.start();
		}
	}
}