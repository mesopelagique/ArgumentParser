Class extends Object

Class constructor($name : Text; $help : Text; $options : Object)
	Super:C1705($name; $help; $options)
	This:C1470.parsers:=New collection:C1472()
	This:C1470.options:=New collection:C1472()
	This:C1470.flags:=New collection:C1472()
	This:C1470.arguments:=New collection:C1472()
	
	// MARK:- configure
	
	// Add a subcommand with it's own options/flag and arguments
Function addParser($name : Text; $help : Text)->$parser : cs:C1710.ArgumentParser
	$parser:=cs:C1710.ArgumentParser.new($name; $help)
	$parser.name:=$name
	This:C1470.parsers.push(New object:C1471("name"; $name; "value"; $parser))
	
	// Add a subcommand with it's own options/flag and arguments
	// But here you could pass one that subtype cs.ArgumentParser
Function addParserInstance($parser : cs:C1710.ArgumentParser)->$out : cs:C1710.ArgumentParser
	ASSERT:C1129(Length:C16(String:C10($parser.name))>0; "The parse must defined its own name")
	This:C1470.parsers.push(New object:C1471("name"; $parser.name; "value"; $parser))
	$out:=$parser
	
	// TODO: manage default command if not a lot of options at root level
	
	// Add argument, ie. values after all options and flag consumed
Function addArgument($name : Text; $help : Text; $options : Object)->$argument : cs:C1710.Argument
	$argument:=cs:C1710.Argument.new($name; $help; $options)
	This:C1470.arguments.push(New object:C1471("name"; $name; "value"; $argument))
	
	// Add a flag, ie a boolean value data
Function addFlag($name : Text; $help : Text; $options : Object)->$flag : cs:C1710.Flag
	$flag:=cs:C1710.Flag.new($help; $options)
	This:C1470.flags.push(New object:C1471("name"; $name; "value"; $flag))
	
	// Add an option to get input data
Function addOption($name : Text; $help : Text; $options : Object)->$option : cs:C1710.Option
	$option:=cs:C1710.Option.new($name; $help; $options)
	This:C1470.options.push(New object:C1471("name"; $name; "value"; $option))
	
	// MARK:- functions
Function usageOneLine()->$usage : Text
	$usage:="Usage : "+This:C1470.name+" "
	// TODO: add exemple according to args/opts/flags
	
Function usage()->$usage : Text
	$usage:=This:C1470.help+"\n"
	$usage+="\n"
	$usage+=This:C1470.usageOneLine()
	$usage+="\n"
	
	var $entity : Object
	
	// TODO: add short option : ex: -h --help     Show this screen.
	If ((This:C1470.options.length>0) || (This:C1470.flags.length>0))
		$usage+="Options:\n"
		For each ($entity; This:C1470.options)
			$usage+="\t"+$entity.name+"\t"+$entity.value.help+"\n"
		End for each 
		For each ($entity; This:C1470.flags)
			$usage+="\t"+$entity.name+"\t"+$entity.value.help+"\n"
		End for each 
		$usage+="\n"
	End if 
	
	If (This:C1470.parsers.length>0)
		$usage+="SUBCOMMANDS:\n"
		For each ($entity; This:C1470.parsers)
			$usage+="\t"+$entity.name+"\t\t"+$entity.value.help+"\n"
		End for each 
		$usage+="\n"
		// $usage+="See '"+This.name+" <subcommand> --help <subcommand>' for detailed help.
	End if 
	
Function _getObject($text : Text)->$object : cs:C1710.Object
	$object:=This:C1470.parsers._getObject($text)
	If ($object#Null:C1517)
		return 
	End if 
	This:C1470.options._getObject($text)
	If ($object#Null:C1517)
		return 
	End if 
	This:C1470.flags._getObject($text)
	
	
Function parse($args : Collection)->$parsed : Object
	var $index : Integer
	For ($index; 0; $args.length)
		$object:=This:C1470._getObject($args[$index])
		Case of 
			: ($object=Null:C1517)
				// Must be arguments, so at the end OR failed
			: (OB Instance of:C1731($object; cs:C1710.ArgumentParser))
				$object.parse($args.slice($index+1))
				return 
			: (OB Instance of:C1731($object; cs:C1710.Flag))
				$object.value:=True:C214
				
			Else 
				
		End case 
		
	End for 
	
	
Function run($args : Collection)
	$parsed:=This:C1470.parse($args)
	
	// TODO: if subcommand run subcommand
	If (False:C215)
		
	Else 
		If (Asserted:C1132(OB Instance of:C1731(This:C1470.action; 4D:C1709.Function); "You must defined an action to run as `action` function/formula"))
			//%W-550.2
			This:C1470.action($parsed)
			//%W+550.2
		End if 
	End if 
	
	