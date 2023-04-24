template "BtrFS Inode"

//Created by Jens Kirschner, 2020
//The trick is finding the inode in the first place...

description "To be applied to beginning of an Inode structure"
applies_to disk

begin
	section "INODE ITEM"
	section "Taking your word for that: Good luck!"

				int64 	generation 	
				int64 	transid 	
				int64 	filesize
				int64 	allocsize
				int64 	ifFreeBG //Unused for normal inodes. Contains byte offset of block group when used as a free space inode.
				uint32 	HardLinkCount
				uint32 	uid
				uint32 	gid

				section "File mode"
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
					hex 2 "Mode extra"
				endsection
		
				int64 	"rdev (devices only)"
				hex 8		"Flags"
				int64 	"Update Seq. No."
					
				hex 32	reserved
				UNIXDateTime	"Access"
				move 4 //btrfs uses 8 bytes for a date, not 4
				uint32	"Access nsecs"
				UNIXDateTime	"Inode change"
				move 4 //btrfs uses 8 bytes for a date, not 4
				uint32	"Inode Ch. nsecs"
				UNIXDateTime	"Modification"
				move 4 //btrfs uses 8 bytes for a date, not 4
				uint32	"Modification nsecs"
				UNIXDateTime	"Creation"
				move 4 //btrfs uses 8 bytes for a date, not 4
				uint32	"Creation nsecs"

end