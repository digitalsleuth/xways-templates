template "Ext4 Extent Block"

// By Jens Kirschner

description "Can be applied to a block containing Ext4 Extents "
applies_to disk
requires 0 "0A F3"

begin
	section "Extents header"
		hex 2 	"Magic 0A F3"
		uint16	"Valid entries"
		uint16	"Max. capacity"
		uint16	"Depth"
		uint32	"Generation"

		//The header is followed by specified number of entries,
		//either pointing to children (if depth > 0), in which case
		//we call this object an index, or (if depth=0) actually
		//pointing to the file's contents, i.e. this is a leaf.

	numbering 1
	{
		ifequal "Depth" 0
			section "Leaf ~"
				uint32	"Logical start block"
				uint_flex "15" "Not initialised?" 
				move -4
				uint_flex "14,13,12,11,10,9,8,7,6,5,4,3,2,1,0" "Extent length"
				move -2
				uint16	"Hi2Bytes phys. start"
				uint32	"Lo4Bytes phys. start"
		else
			section "Index ~"
				uint32	"Logical start block"
				uint32	"Lo4Bytes phys. start"
				uint16	"Hi2Bytes phys. start"
				uint16	"Unused"
		endif

	}[Valid Entries]

end