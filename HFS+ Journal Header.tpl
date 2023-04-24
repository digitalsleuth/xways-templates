template "HFS+ Journal Header"
description "to be applied to beginning of .journal on HFS+"

//by Jens Kirschner

applies_to disk
sector-aligned

requires 0 "78 4c 4e 4a"
requires 4 "78 56 34 12"


begin

section "Journal Header"

	char[4]	"magic (xLNJ)"
	hex 4		"endian (12345678)"
	Int64		start
	Int64		end
	Int64		size
	UInt32	blhdr_size
	UInt32	checksum
	UInt32	jhdr_size

section "Next sector: Block List Header"

end