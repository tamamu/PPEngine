package;

import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.Assets;

class MusicManager {
	public var channel:SoundChannel;
	public var musics:Array<Sound>;
	public var current:Int;
	public function new(){
		current=-1;
		musics=new Array<Sound>();
	}
	public function addMusic(path:String){
		musics[musics.length]=Assets.getSound(path);
	}
	public function play(id:Int, ?stop:Bool = false){
		if(channel==null){
			channel=musics[id].play();
		}else if(stop || current!=id){
			channel.stop();
			channel=musics[id].play();
		}
		current=id;
	}
	public function stop(){
		channel.stop();
	}
}