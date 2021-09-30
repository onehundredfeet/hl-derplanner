genhl:
	haxe -cp generator  -lib hl-idl --macro "derplanner.Generator.generateCpp()"
	
genjs:
	haxe -cp generator -lib hl-idl --macro "derplanner.Generator.generateJs()"
