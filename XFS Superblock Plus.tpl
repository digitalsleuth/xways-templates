template "XFS Superblock+"

//by Jens Kirschner

//Parses Superblock (v4 and v5), Free Space Info, Inode Info and Free List sectors,
//but skips fields we don't find too relevant for simplicity reasons

description "Parses first four sectors of an XFS partition"  //technically of each AG
applies_to disk
sector-aligned
big-endian 		//SGI IRIX inheritance
multiple   //actually allows moving from one AG to the next!

requires 0x00	"58 46 53 42"	//Signature "XFSB" 

begin
	section "Sector 0: Superblock"

	char[4]  "Signature: XFSB"
	uint32   BlockSize  //typically 4KB
	int64    "Block count"
	
	move 16 //skipping next two fields
	
//	int64    "Block count (RT)" //real-time devices
//	int64    "Extent count (RT)"
	GUID	 "UUID"
	
	int64    "Journal start block"
	int64    "Root Inode"  //typically 96 (512 B inode size) or 128 (256 B)
	
	move 20  //skipping next three fields
//	int64    "RT ExtentBitmap Inode"
//	int64    "RT Summary Inode"
//	uint32   "RT Extent size (blocks)"
	uint32   AGBlockCount
	uint32   "AG count"
	
	move 4 //skipping next field
	
//	uint32   "RT Bitmap block count"
	uint32   "Journal block count"
	hex 2    "Version (w Flags)"
	
	section "V4 or V5 Superblock?"

	move -1		//for the additional v5 SB fields, we have to strip out the actual version number
	Little-Endian hexadecimal uint_flex "3,2,1,0" SBVersion
	move -3
	
	endsection
	
	uint16   SectorSize  //not necessarily the same as the actual sector size!
	uint16   "Inode size" //default 256B (with CRC: min 512B), up to 2KB possible
	uint16   "Inodes per block" //should work out as blocksize div Inode size
	char[12] "FS name"

	uint8    "Block size (2^x)"	//binary logarithm of block size
	uint8    "Sector size (2^x)"
	uint8    "Inode size (2^x)"
	uint8    "Inodes per block (2^x)"
	uint8    "~AG blocks (2^x)"
	
	move 1 //skipping next
	
//	uint8    "RT extents (2^x)"
	hex 1    "Flag 'in progress'"
	uint8    "Max. inode %"
	int64    "Inode count"		//globally, as opposed to current AG only (maintained in first superblock only)
	int64    "Inodes free"		//ditto...
	int64    "Free blocks"		//...
	
	move 48 //skipping a couple of fields that are not terribly interesting 
	
	//specifically these:
	
//	int64    "Free RT extents"		//...
//	int64    "User quota inode"	//only exists if user quotas in use
//	int64    "Group quota inode"	//ditto groups
//	hex 2    "Quota flags"
//	hex 1    "More flags"
//	hex 1    "Shared version number"  
//	uint32   "Inode chunk alignment (blocks)"
//	uint32   "Stripe unit"
//	uint32   "Stripe width"
//	uint8		"lb(Dir block granularity)"
//	uint8		"lb(journal sector size)"
//	uint16	"Journal dev sector size"
//	uint32	"Journal stripe size"
	
	section	"Extra feature flags"
	hexadecimal uint32	Features2
	
	ifGreater Features2 0
		move -4
		uint_flex "25"	"Lazy Superblock" //counters updated on clean unmount only!
		move -4
		uint_flex "27"	"EA inodes v2"
		move -4
		uint_flex "16"	"CRCs enabled"
	endif

	endsection
	
	hexadecimal uint32	BadFeatures2   //should be empty, usually duplicate of Features2
	
	ifEqual SBVersion 5
		section "Version 5 SB Fields"
	
		hex 4	"Compat. Features"
		endsection
		
		hex 4	"RO compat. Features"
		move -4
		uint_flex "24"	"HasFreeInodeBTree"
		endsection
		
		hex 4	"Incompat. Features"
		move -4
		uint_flex "24"	"FType in DirEntry"
		move -4
		uint_flex "26"	"HasMetaUUID"
		endsection
		
		hex 4 "Jrnl-incompat. Features"
		endsection
		
		Little-Endian uint32	"SB CRC"    //the only field in the entire SB structure that is defined as LE

		move 12 //skipping next two fields
		 
//		hex 4	"Padding"
//		int64	"Proj. Quota Inode"
		int64	"Last Write Seq."
		
//		ifEqual HasMetaUUID 1   //decided to show it even if empty
			GUID	"Meta UUID"
//		end
	endIf 
	
	goto 0
	move SectorSize   //going to next sector
	
	section "Sector 1: AG Free Info"
	
	char[4]	"AGF Magic"
	uint32	"AGF version"
	uint32	"This AG no"
	uint32	"AG size (blocks)"
	uint32	"Root of BlockNoFreeSpaceTree"	//there are two free space trees, one sorted by block numbers (this one)
	uint32	"Root of BlockCountFreeSpaceTree"  //and one sorted by size of the consecutive free space (this one)
	move 4 //unused
	uint32	"Depth of BlockNoFreeSpaceTree"
	uint32	"Depth of BlockCountFreeSpaceTree"
	move 4 //unused
	uint32	"First FreeList block"
	uint32	"Last FreeList block"
	uint32	FreeListBlockCount
	uint32	"AG free blocks"
	uint32	"AG longest contig. free space"
	uint32	"FreeSpace tree block count" //Note: commonly unmaintained
	
	ifEqual SBVersion 5
		section "Version 5 AGF Fields"
		
		GUID	"AGF UUID"
	
		move (8*16)  //skipping spares
	
		int64	"Last Write Seq."
		uint32	"AGF CRC"
	EndIf
	
	goto 0
	move (2*SectorSize)   //going to next sector
	
	section "Sector 2: AG Inode Info"
	
	char[4]	"AGI Magic"
	uint32	"AGI version"
	uint32	"This AG no"
	uint32	"AG size (blocks)"
	uint32	"Inodes in this AG"	
	uint32	"Root of InodeTree"		//Inodes managed by B+Tree
	uint32	"Depth of InodeTree" 
	uint32	"Free inodes"
	uint32	"Most recently allocated inode"
	move 4 //unused
	
	section "Unlinked inodes bucket"
	numbering 0 {
		uint32	"Unlinked inode ~"
	} [4]
	
	move (59*4)  //skipping most of them
	section "[...]"
	
	uint32	"Unlinked inode 63"
	
	ifEqual SBVersion 5
		section "Version 5 AGI Fields"
		
		GUID	"AGI UUID"
		uint32	"AGI CRC"
		
		move 4  //skipping padding
		
		int64  "AGI Last Write Seq."
		uint32	"Root of FreeInodeTree"		//Free Inodes managed by separate B+Tree
		uint32	"Depth of FreeInodeTree" 		
	EndIf	
	
	goto 0
	move (3*SectorSize)   //going to next sector
	
	section "Sector 3: AG Free List"	
	
	ifEqual SBVersion 5
		section "Version 5 Free List Header"
		char[4]	"AFL Magic"
		uint32	"AFL Seq.No."
		GUID	"AFL UUID"
		int64   "AFL Last Write Seq."
		uint32	"AFL CRC"
		endsection
	Else
		section "No Free List headers in V4"
	EndIf
	
	numbering 0 {
		uint32	"FreeListBlock ~"
	} [FreeListBlockCount]
	
	goto (AGBlockCount*BlockSize)  //going to next AG beginning for "multiple"
	
end