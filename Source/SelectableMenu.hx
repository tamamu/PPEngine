package;

interface SelectableMenu {
	//private var items:Array<Dynamic>;
	//private var menuItems:Array<Dynamic>;
	public var menuFuncs:Array<Void -> Void>;
	//private var cursor:Dynamic;
	public var selected:Int;
	//public function selectItem(idx:Int):Void;
	public function selectItem(idx:Int):Bool;
	public function stop():Void;
	public function execItem():Bool;
	public function selectPrev():Bool;
	public function selectNext():Bool;
}