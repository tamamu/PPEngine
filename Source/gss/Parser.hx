package gss;

using unifill.Unifill;
using gss.Command;

class Parser {
	static public function skipSpaces(str:String){
		return StringTools.ltrim(str);
	}

	static public function read(str:String):Array<Command>{
		var src=str.uSplit("\n");
		var commands=new Array<Command>();
		for(srcIdx in 0...src.length){
			src[srcIdx]=skipSpaces(src[srcIdx]);
			if(src[srcIdx]=="")continue;
			commands=commands.concat(readLine(src[srcIdx]));
		}
		return commands;
	}

	static public function readLine(str:String):Array<Command>{
		switch (str.uCharAt(0)) {
			case '#':
				return scanCommand(str.uSubstring(1));
			default:
				return scanMessage(str);
		}
	}

	static public function scanCommand(str:String):Array<Command>{
		var result=new Array<Command>();
		return result;
	}

	static public function scanMessage(str:String):Array<Command>{
		var result=new Array<Command>();
		var pauseIdx=-1;
		while(str.uLength()>0){
			pauseIdx=-1;
			pauseIdx=str.uIndexOf("\\");
			if(pauseIdx>=0){
				result[result.length]=Put(str.uSubstring(0, pauseIdx));
				result[result.length]=Pause;
				str=str.uSubstring(pauseIdx+1);
			}else{
				result[result.length]=Put(str);
				str="";
			}
		}
		result[result.length]=BreakLine;

		return result;
	}
}