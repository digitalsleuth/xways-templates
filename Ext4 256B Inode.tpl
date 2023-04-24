template "Ext4 256B Inode"

// By Jens Kirschner

// This template expects to be applied to inodes that are at least 256B in
// size as the fields at the end would not actually fit into the older 128B
// inode format

description "Contains a file's meta information (using Extents)"
applies_to disk
multiple

begin

	section "File Mode"

		octal uint_flex "8,7,6,5,4,3,2,1,0" "Permissions"

		move -4
		uint_flex "15,14,13,12" "File type (8=reg.file, 4=dir.)"

		move -4
		uint_flex "9" "Sticky bit"
	
		move -4
		uint_flex "10" "SGID"

		move -4
		uint_flex "11" "SUID"

		move -2
	endsection

	uint16	"Owner user ID (low 2 bytes)"
	uint32	"Size in bytes (low 4 bytes)"
	UNIXDateTime	"Access time"
	UNIXDateTime	"Inode change"
	UNIXDateTime	"Modification"
	UNIXDateTime	"Deletion"
	uint16	"Group ID (low 2 bytes)"
	uint16	"Hard-link count"
	uint32	"Sector count (low 4 bytes)"
	uint32	"File flags"
	move -4
	uint_flex "19" "Extents"
	uint32	"OS dependent"

	ifequal "Extents" 0
		section "No extents in use."
		section "Please use a different Ext Inode template."
	endif
	
	section "Extents Header"
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

	endsection

	goto 100

	uint32	"File version (low 4 bytes)"
	uint32	"File ACL (low 4 bytes)"
	uint32	"Size in bytes (high 4 bytes)"
	uint32	"(obsolete)"

	section "OS dependent"
		uint16	"Sector count (high 4 bytes)"
		uint16	"File ACL (high 4 bytes)"
		uint16	"Owner user ID (high 2 bytes)"
		uint16	"Group ID (high 2 bytes)"
		hex 4		reserved
	endsection
	
	uint16	"extra isize"
	hex 2		padding
	
	uint_flex "31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2" "Inode change ref. (nsec)"
	move -4
	uint_flex "1,0" "Inode change epoch"

	uint_flex "31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2" "Modification ref. (nsec)"
	move -4
	uint_flex "1,0" "Modification epoch"

	uint_flex "31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2" "Access time ref. (nsec)"
	move -4
	uint_flex "1,0" "Access time epoch"

	UNIXDateTime	"Creation"
	
	uint_flex "31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2" "Creation ref. (nsec)"
	move -4
	uint_flex "1,0" "Creation epoch"

	uint32	"File version (high 4 bytes)"
	
	goto 0
	move 256 // Change this for a different Inode size
end