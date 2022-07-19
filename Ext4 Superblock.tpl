template "Ext4 Superblock"

// Created by Jens Kirschner

// The first superblock always starts at position 1024 regardless 
// of sector or block sizes on the system. There will be a copy of 
// it in every blockgroup of the drive, always as the first block 
// of the group, UNLESS the "sparse superblock feature" is set on 
// the drive. This is standard these days and will cause the 
// superblock copies to exist only in blockgroups 0, 1 and all 
// powers of 3, 5 and 7. The other blockgroups will neither have 
// superblocks nor group descriptor tables 


description "To be applied to offset 1024 of an Ext4 partition"
applies_to disk
sector-aligned

requires 0x38 "53 EF" // ext2 magic 

begin
	uint32	"Inode count"
	uint32	"Block count"
	uint32	"Reserved block count"
	uint32	"Free block count"
	uint32	"Free Inode count"
	uint32	"First data block"
	uint32	"Block size (0=1K, 1=2K, 2=4K)"
	int32		"Fragment size (same)"
	uint32	"Blocks per group"
	uint32	"Fragments per group"
	uint32	"Inodes per group"
	UNIXDateTime	"Last mount time"
	UNIXDateTime	"Last write time"
	uint16	"Mount count"
	int16		"Maximal mount count"
	hex 2		"Magic signature (53 EF)"
	uint16	"File system state"
	uint16	"Behavior when detecting errors"
	uint16	"Minor revision level"
	UNIXDateTime	"Time of last check"
	uint32	"Max. time between checks (sec)"
	uint32	"OS (0: Linux)"
	uint32	"Revision level"
	uint16	"User ID for reserved blocks"
	uint16	"Group ID for reserved blocks"

		section "Extended Superblock Section"	
		uint32	"First non-reserved Inode"
		uint16	"Inode size"
		uint16	"This superblock's block group"

		section "Compatibility Feature Flags"
		uint_flex "2" "Has journal"
		move -4
		hex 4	All

		section "Incompatibility Feature Flags"
		uint_flex "1" "Filetype in dir. entry"
		move -4
		uint_flex "6" "Extents used"
		move -4
		uint_flex "7" "64-bit block numbers"
		move -4
		uint_flex "9" "Flexible block groups"
		move -4
		hex 4 All

		section "RO-compatibility Feature Flags"
		uint_flex "0" "Sparse superblock"
		move -4
		hex 4 All
		endsection 

		hex 16	"UUID of the volume"
		char[16]	"Volume name"
		char[64] "Last mounted path"
		uint32	"Algorithm usage bitmap" 
		uint8		"Blocks preallocation"
		uint8		"Directory blocks preallocation"
		uint16	"Reserved GDT blocks" //GDT=Group Descriptor Table
		hex 16	"Journal UUID"
		uint32	"Journal Inode"
		uint32	"Journal device #"
		uint32	"Last orphaned Inode"
		numbering 1 {
			uint32	"Hash seed ~"
		} [4]
		uint8		"Default hash version"
		uint8		"Jrnl backup type"
		uint16	"Grp Desc size"
		uint32	"Default mount options"
		uint32	"First metablock block group"
		UNIXDateTime	"Filesystem creation"
		
		section "Journal Inode Backup" //17x 4 bytes
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
				uint16	"Extent length"
				uint16	"HiWord phys. start"
				uint32	"LoDWord phys. start"
		else
			section "Index ~"
				uint32	"Logical start block"
				uint32	"LoDWord phys. start"
				uint16	"HiWord phys. start"
				uint16	"Unused"
		endif

	}[4]

	endsection

		uint32	"Journal filesize (hiDWord)"
		uint32	"Journal filesize"			

		section "64-bit Support"
		uint32	"Block count hi DWord"
		uint32	"Res. blocks hi DWord"
		uint32	"Free blocks hi DWord"

		endsection
		
		uint16	"min extra isize"
		uint16	"want extra isize"
		hex 4	"Misc flags"
		uint16	"RAID stride"
		uint16	"MMP interval" //Multi-mount prevention wait time
		int64	"MMP block"
		uint32	"RAID stripe width"
		uint8	"lb groups per flex"
		uint8	"checksum type"
		uint16	"reserved"
		int64	"KiB written"  //literally: total KiB written over FS lifetime
		uint32	"snapshot inode"
		uint32	"snapshot ID"
		int64	"snapshot res. blocks"
		uint32	"snapshot list inode"
		
		section "Error statistics"
		uint32	"Error count"
		UNIXDateTime	"First error"
		uint32	"First error inode"
		int64	"First error block"
		char[32]	"First error function"
		uint32	"First error line"
		
		UNIXDateTime	"Last error"
		uint32	"Last error inode"
		uint32	"Last error line"
		int64	"Last error block"
		char[32]	"Last error function"
		
		endsection
		
		char[64]	"Mount options"
		
		
end