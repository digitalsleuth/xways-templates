template "HFS+ Journal Block List Header"
description "to be applied to second sector of .journal on HFS+"

//by Jens Kirschner

applies_to disk
sector-aligned
multiple

begin

section "Block List Header"

	UInt16	maxBlocks
	UInt16	numBlocks
	UInt32	bytesUsed
	UInt32	checksum
	UInt32	"pad (?)"

numbering  0
{
	section "Block Info ~"
		Int64		"destination sector"
		UInt32	size
		UInt32	next
} [10]

section "Template always shows 10 entries!"

goto 0 
move bytesUsed

end