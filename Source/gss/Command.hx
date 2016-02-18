package gss;

enum Command{
	Put(msg:String);
	BreakLine;
	Pause;
	EOF;
}