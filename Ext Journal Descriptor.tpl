template "Ext4 Journal Descriptor block"

//Template by Jens Kirschner

description "Apply to block of type 1"

sector-aligned
big-endian   //ext* are LE file systems, but the Journal is BE!

requires 0 "C0 3B 39 98"

begin
	section "Block Header"
	hex 4 "Jrnl Magic C0 3B 39 98"
	uint32 "Block Type (1=descriptor)"
	uint32 "This block's trans. ID"	
	
	section "No incompat features assumed!"
	
	//For explanation: the exact format for the individual
	//descriptor items actually varies, depending on which
	//incompatible features are enabled in the journal 
	//superblock. This template uses the layout as applicable
	//with *no* incompatible features enabled!	

	numbering 0 {	
	
		section "Block tag ~"
		uint32 "Destination blocknum"
		uint16 "checksum"
		hex 2	"Flags"
	
		move -1
		uint_flex "1" "Same UUID"
		move -4
		uint_flex "3" "Last tag"
		move -3
	
		ifEqual "Same UUID" 0
			hex 16 "UUID"
		EndIf

		ifEqual "Last tag" 1
			ExitLoop
		EndIf
	}[100] //putting in a sane upper limit, just in case
	

end