package why.email;

using StringTools;

@:forward
abstract Address(AddressBase) from AddressBase to AddressBase {
	@:from
	public static function parse(v:String):Address {
		var re = ~/^(.*)\s?<(.*)>$/;
		return if(re.match(v)) {
			var name = re.matched(1).trim();
			if(name.charCodeAt(0) == '"'.code && name.charCodeAt(name.length - 1) == '"'.code)
				name = name.substr(1, name.length - 2);
			{name: name, address: re.matched(2)}
		} else {
			{address: v}
		}
	}
	
	@:to
	public function toString():String {
		return if(this.name == null) this.address else '"${this.name}" <${this.address}>';
	}
}

private typedef AddressBase = {
	@:optional var name(default, never):String;
	var address(default, never):String;
}