import cbs.Player;

class Test {
	static var p=new Player();
	static var e=new Player();
	static public function main():Void {
		trace(jumpBall(p, e));
	}

	static public function jumpBall(playerA:Player, playerB:Player){
		var sumA=playerA.height+playerA.jump;
		var sumB=playerB.height+playerB.jump;
		if(sumA > sumB){
			return true;
		}else if(sumA == sumB){
			if(Math.random()>0.5){
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}
}