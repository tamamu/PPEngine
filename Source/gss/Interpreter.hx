package gss;

using gss.Command;

class Interpreter {
	public var commands:Array<Command>;
	public var index:UInt;
	public function new(){
		commands=new Array<Command>();
		index=0;
	}
	public function load(src:String){
		commands=Parser.read(src);
	}
	public function next():Command{
		if(index>=commands.length){
			return EOF;
		}
		index++;
		return commands[index-1];
	}
}