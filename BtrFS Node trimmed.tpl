template "BtrFS Node (trimmed+ordered)"

//Created by Jens Kirschner, 2020

//Single template for all kinds of BtrFS Tree Nodes, regardless
//of tree, both internal and Leaf Nodes - slimmed down version to
//reduce output to just key information - though the skipped parts
//are still visible as comments


description "Slimmed down parsing for B-Tree Node"
applies_to disk
sector-aligned

begin
	section "Node Header"

	move 48 	//hex 32 	Checksum 	// Checksum of everything past this field (from 20 to 1000)
				//guid		"FS UUID"
	int64		"This node's logical ofs"  //resolved to physical via CHUNK TREE
	move 32 	//hex 7		flags
				//byte		"Revision (0 or 1)" //old or new
				//guid		"Chunk Tree UUID"
				//int64		generation
	int64		"TreeObjectID"

	ifEqual TreeObjectID 1
		section "This is a ROOT TREE node"
	endif

	ifEqual TreeObjectID 2
		section "This is an EXTENT TREE node"
	endif

	ifEqual TreeObjectID 3
		section "This is a CHUNK TREE node"
	endif

	ifEqual TreeObjectID 4
		section "This is a DEV TREE node"
	endif

	ifEqual TreeObjectID 5
		section "This is an FS TREE node"
	endif

	ifEqual TreeObjectID 7
		section "This is a CSUM TREE node"
	endif

	ifEqual TreeObjectID 9
		section "This is a UUID TREE node"
	endif

	ifEqual TreeObjectID 10
		section "This is a FREE SPACE TREE node"
	endif


	uint32	ItemCount
	byte		Level

	endsection


	ifGreater Level 0
		section "Internal Node Key Pointers"

		numbering 0 {
			section "Key ~"
			int64	ObjectID~
			byte	ItemType~
			int64	Offset~   //despite the name, this field can mean all sorts of things
			endsection

			int64	BlockOfs  //resolved to physical via CHUNK TREE
			int64	Generation

		} [ItemCount]


		exit
	Endif


		section "Leaf Node Entries"

		numbering 0 {
			section "Key ~"
			int64	ObjectID
			byte	ItemType
			int64	Offset   //despite the name, this field can mean all sorts of things
			endsection

			uint32	DataOfs
			uint32	DataSize

			goto (101+DataOfs)  

			ifEqual ItemType 108
				section "Data Item ~ is Type 108: EXTENT DATA"

				move 8	//int64	generation
				int64	"size of decoded extent"
				byte	"compression (1=zlib, 2=LZO)"
				byte	encryption
				uint16	"other encoding"
				byte	"type (0=inline, 1=reg, 2=prealloc)"

				section "Extent garbage if inline"
				int64	"log. address"
				int64	"extent size"
				int64	"Ofs in file"
				int64	"file size"
			endif

			ifEqual ItemType 132
				section "Data Item ~ is Type 132: ROOT ITEM"

				section "Inode section"
				move 16	//int64 	generation 	
							//int64 	transid 	
				int64 	filesize
				int64 	"what is this really?"
				move 8	//int64 	ifFreeBG //Unused for normal inodes. Contains byte offset of block group when used as a free space inode.
				uint32 	HardLinkCount
				uint32 	uid
				uint32 	gid

				section "File mode"
					octal uint_flex "8,7,6,5,4,3,2,1,0" "Permissions"
					move -4
					uint_flex "15,14,13,12" "File type (8=reg.file, 4=dir.)"
					//move -4
					//uint_flex "9" "Sticky bit"
					//move -4
					//uint_flex "10" "SGID"
					//move -4
					//uint_flex "11" "SUID"
					//move -2
					//hex 2 "Mode extra"
				endsection
		
				move 8	//int64 	"rdev (devices only)"
				hex 8		"Flags"
				move 40	//int64 	"Update Seq. No."
					
							//hex 32	reserved
				UNIXDateTime	"Access"
				move 8	//4 //btrfs uses 8 bytes for a date, not 4
							//uint32	"Access nsecs"
				UNIXDateTime	"Inode change"
				move 8	//4 //btrfs uses 8 bytes for a date, not 4
							//uint32	"Inode Ch. nsecs"
				UNIXDateTime	"Modification"
				move 8	//4 //btrfs uses 8 bytes for a date, not 4
							//uint32	"Modification nsecs"
				UNIXDateTime	"Creation"
				move 16	//4 //btrfs uses 8 bytes for a date, not 4
							//uint32	"Creation nsecs"
				endsection 

							//int64 	generation_txid
				int64 	root_dirid 	//For file trees, the objectid of the root directory in this tree (always 256). Otherwise, 0.
				int64 	RootNodeOffset

				move (16+8+8+4+8+1+8+1)
							//hex 16	unused

							//int64 	last_snapshot_txid
							//hex 8		flags
							//uint32 	refcount //Originally indicated a reference count. In modern usage, it is only 0 or 1.

							//section "Last dropped item"
							//int64	ObjectID
							//byte	ItemType
							//int64	Offset
							//byte	level
							//endsection
				
				byte	TreeHeight

				move (8+3*16+4*8)
							//int64 generation_txid2 //If equal to generation, indicates validity of the following fields.

							//guid	SubvolumeUUID
							//guid	ParentUUID
							//guid	ReceivedUUID

							//int64 lastChangeTXID				
							//int64 treeCreationTXID				
							//int64 lastSentTXID	//The transid for the transaction that sent this subvolume. Nonzero for received subvolume.
							//int64 lastReceivedTXID	//The transid for the transaction that received this subvolume. Nonzero for received subvolume.				
			
				UNIXDateTime	"Last Change"
				move 8	//4 //btrfs uses 8 bytes for a date, not 4
							//uint32	"Last Change nsecs"
				UNIXDateTime	"Tree Creation"
							//move 4 //btrfs uses 8 bytes for a date, not 4
							//uint32	"Tree Creation nsecs"
							//UNIXDateTime	"Last Sent"
							//move 4 //btrfs uses 8 bytes for a date, not 4
							//uint32	"Last Sent nsecs"
							//UNIXDateTime	"Last Received"
							//move 4 //btrfs uses 8 bytes for a date, not 4
							//uint32	"Last Received nsecs"
				
							//hex 64	reserved				
			endif

			ifEqual ItemType 156
				section "Data Item ~ is Type 156: ROOT REF ITEM"

				int64	"DirID that contains subtree"
				int64	"Sequence/Index in Dir"
				uint16	NameLen
				char[NameLen] "Name"
			endif


			ifEqual ItemType 144
				section "Data Item ~ is Type 144: ROOT BACKREF ITEM"

				int64	"DirID that contains subtree"
				int64	"Sequence/Index in Dir"
				uint16	NameLen
				char[NameLen] "Name"
			endif

			ifEqual ItemType 96
				section "Data Item ~ is Type 96: DIR INDEX"

				int64		KeyObjID
				byte		KeyItemType
				int64		KeyOfs
				move 10
							//int64		transid
							//uint16	dataLen //for use in xattr items only, otherwise 0
				uint16	nameLen
				byte		"Type (1=reg 2=dir 7=symlink)"
				char[nameLen]	Name

				//structurally identical to DIR ITEM, but never allows
				//more than one entry
			endif


			ifEqual ItemType 84
				section "Data Item ~ is Type 84: DIR ITEM"

				int64		KeyObjID
				byte		KeyItemType
				int64		KeyOfs
				move 10
							//int64		transid
							//uint16	dataLen //for use in xattr items only, otherwise 0
				uint16	nameLen
				byte		"Type (1=reg 2=dir 7=symlink)"
				char[nameLen]	Name

				section "More entries following?"

				//there could be more entries following here, but the template
				//doesn't know that - would need deciding based on whether the
				//item data size for this item continues or has been fully 
				//parsed already
			endif

			ifEqual ItemType 12
				section "Data Item ~ is Type 12: INODE REF ITEM"

				int64	"Index in Dir"
				uint16	"namelen"
				char[namelen] "Name in Dir"
			endif


			ifEqual ItemType 1
				section "Data Item ~ is Type 1: INODE ITEM"

				move 16	//int64 	generation 	
							//int64 	transid 	
				int64 	filesize
				int64 	"what is this really?"
				move 8	//int64 	ifFreeBG //Unused for normal inodes. Contains byte offset of block group when used as a free space inode.
				uint32 	HardLinkCount
				uint32 	uid
				uint32 	gid

				section "File mode"
					octal uint_flex "8,7,6,5,4,3,2,1,0" "Permissions"
					move -4
					uint_flex "15,14,13,12" "File type (8=reg.file, 4=dir.)"
					//move -4
					//uint_flex "9" "Sticky bit"
					//move -4
					//uint_flex "10" "SGID"
					//move -4
					//uint_flex "11" "SUID"

					//move -2
					//hex 2 "Mode extra"
				endsection
		
				move 8	//int64 	"rdev (devices only)"
				hex 8		"Flags"
				move 40	//int64 	"Update Seq. No."
					
							//hex 32	reserved
				UNIXDateTime	"Access"
				move 8	//4 //btrfs uses 8 bytes for a date, not 4
							//uint32	"Access nsecs"
				UNIXDateTime	"Inode change"
				move 8	//4 //btrfs uses 8 bytes for a date, not 4
							//uint32	"Inode Ch. nsecs"
				UNIXDateTime	"Modification"
				move 8	//4 //btrfs uses 8 bytes for a date, not 4
							//uint32	"Modification nsecs"
				UNIXDateTime	"Creation"
							//move 4 //btrfs uses 8 bytes for a date, not 4
							//uint32	"Creation nsecs"
				endsection 
			EndIF


			ifEqual ItemType 216
				section "Data Item ~ is Type 216: DEV_ITEM"
				int64 	"device id"
				int64 	"number of bytes"
				int64 	"number of bytes used"
				uint32	"optimal I/O align"
				uint32	"optimal I/O width"
				uint32	"min. I/O size (sector size)"
				int64 	type
				int64 	generation
				int64 	"start offset"
				uint32	"dev group"
				byte		"seek speed"
				byte		bandwidth
				guid		"device UUID"
				guid		"FS UUID"
			EndIF

			ifEqual ItemType 228
				section "Data Item ~ is Type 228: CHUNK_ITEM"
				int64		"size of chunk (bytes)"
				int64		"root referencing this chunk (2)"
				int64		"stripe length"
				hex 8		"Type Flags" // (same as flags for block group?)
				move -8 
				uint_flex "2,1,0"	"1=DATA, 2=SYS, 4=META"
				move -4 
				uint_flex "5"	"DUP used"
				move -4 
				uint_flex "3"	"RAID0"
				move -4 
				uint_flex "4"	"RAID1"
				move -4 
				uint_flex "6"	"RAID10"
				//the next two would be for RAID5 and RAID5, but those are not officially supported in btrfs yet

				move 4
				uint32	"optimal io alignment"
				uint32	"optimal io width"
				uint32	"min. io size (sector size)"
				uint16	StripeCount
				uint16	"sub stripes"

				section "Stripe 1"
				int64		"device id"
				int64		offset
				GUID		"device UUID"
	
				section "only one stripe shown"
			EndIF


			goto (126+~*25)  				
		
			ifGreater ~ 30
				exit
			EndIf

		} [ItemCount]



end