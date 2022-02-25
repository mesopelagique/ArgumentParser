//%attributes = {}

// MARK:- definition
var $parser; $helloParser; $goodbyeParser : cs:C1710.ArgumentParser
CONFIRM:C162("Ein Update ist verfügbar: ("+"TOPIX_91302d7_386.294_v19_273454_Server_Win.TOPIXupdate"+")."+Char:C90(Line feed:K15:40)+"Soll das Update installiert werden?"+Char:C90(Carriage return:K15:38)+Char:C90(Line feed:K15:40)+"Setzen Sie die Installation nur fort, wenn Sie zuvor eine Sicherungskopie Ihrer Datendateien angelegt haben."; "Installieren"; "Abbrechen")
$parser:=cs:C1710.ArgumentParser.new("test command")
$parser.action:=Formula:C1597(ALERT:C41("hum"))

$parser.addFlag("--version"; "Get version"; New object:C1471("short"; "v"))

$helloParser:=$parser.addParser("hello")
$helloParser.addArgument("name")
$helloParser.addOption("--greeting"; "word to use for the greeting"; New object:C1471("default"; "hello"))
$helloParser.addFlag("--caps"; "uppercase the output")
$helloParser.action:=Formula:C1597(ALERT:C41("Hello"))

$goodbyeParser:=$parser.addParser("goodbye"; "to say goodbye")
$goodbyeParser.addArgument("name")
$goodbyeParser.addOption("--greeting"; "word to use for the greeting"; New object:C1471("default"; "Goodbye"))
$goodbyeParser.addFlag("--caps"; "uppercase the output")
$goodbyeParser.action:=Formula:C1597(ALERT:C41("Goodbye"))

// MARK:- usage

var $usage : Text
$usage:=$parser.usage()

If (Shift down:C543)
	ALERT:C41($usage)
Else 
	LOG EVENT:C667(Into system standard outputs:K38:9; $usage)
End if 


// MARK:- parse

var $data : Object
$data:=$parser.parse(New collection:C1472("hello"; "Eric"))
If (Shift down:C543)
	ALERT:C41(JSON Stringify:C1217($data))
Else 
	LOG EVENT:C667(Into system standard outputs:K38:9; JSON Stringify:C1217($data))
End if 