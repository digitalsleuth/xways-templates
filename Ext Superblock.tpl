template "Ext2/Ext3 Superblock"

// Created by Jens Kirschner

// The first superblock always starts at position 1024 regardless 
// of sector or block sizes on the system. There will be a copy of 
// it in every blockgroup of the drive, always as the first block 
// of the group, UNLESS the "sparse superblock feature" is set on 
// the drive. This is standard these days and will cause the 
// superblock copies to exist only in blockgroups 0, 1 and all 
// powers of 3, 5 and 7. The other blockgroups will neither have 
// superblocks nor group descriptor tables 


description "To be applied to offset 1024 of an Ext2/3 partition"
applies_to disk

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

	IfEqual "Revision level" 0
				// no extended superblock section
	Else
		section "Extended Superblock Section"	
		uint32	"First non-reserved Inode"
		uint16	"Inode size"
		uint16	"This superblock's block group"

		section "Compatibility Feature Flags"
		hex 4 "all flags"
		move -4
		uint_flex "2" "Has journal"

		section "Incompatibility Feature Flags"
		hex 4 "all flags"
		move -4
		uint_flex "1" "Filetype in dir. entry"
		move -4
		uint_flex "4" "Meta BG used"
		move -4
		uint_flex "6" "Extents used"
		move -4
		uint_flex "7" "64-bit block numbers"
		move -4
		uint_flex "9" "Flexible block groups"

		section "RO-compatibility Feature Flags"
		hex 4 "all flags"
		move -4
		uint_flex "0" "Sparse superblock"
		endsection 

		hex 16	"UUID of the volume"
		char[16]	"Volume name"
		char[64] "Last mounted path"
		uint32	"Algorithm usage bitmap" 
		uint8		"Blocks preallocation"
		uint8		"Directory blocks preallocation"
		uint16	"Reserved GDT blocks"
		hex 16	"Journal UUID"
		uint32	"Journal Inode"
		uint32	"Journal device #"
		uint32	"Last orphaned Inode"
		numbering 1 {
			uint32	"Hash seed ~"
		} [4]
		uint8		"Default hash version"
		uint8	"Journal backup type"
		uint16	"GDT entry size"
		uint32	"Default mount options"
		uint32	"First metablock block group"
		UNIXDateTime	"Filesystem creation"
		
		section "Journal Inode Backup" //17x 4 bytes
		{
			uint32	"Journal Block ~"
		}[12]
		uint32	"Journal indirect block"
		uint32	"Journal double indirect block"
		uint32	"Journal triple indirect block"
		uint32	"unknown"
		uint32	"Journal filesize"			

		section "64-bit Support"
		uint32	"Block count hi DWord"
		uint32	"Res. blocks hi DWord"
		uint32	"Free blocks hi DWord"
	EndIf
end