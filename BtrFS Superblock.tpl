template "BtrFS Superblock"

//by Jens Kirschner


description "To be applied at offset 65536"
applies_to disk
sector-aligned

requires 0x40 "5F 42 48 52 66 53 5F 4D"  //"_BHRfS_M"

begin
	hex 32 	Checksum 	// Checksum of everything past this field (from 20 to 1000)
	guid		"FS UUID"
	int64		"This block" // 	physical address of this block (different for mirrors)
	hex 8		flags
	char[8] 	"magic (_BHRfS_M)"
	int64		generation
	int64 	"root tree root" //logical address of the root tree root
	int64 	"chunk tree root" //logical address of the chunk tree root
	int64 	"log tree root" //logical address of the log tree root
	int64		log_root_transid
	int64		total_bytes
	int64		bytes_used
	int64		"root_dir_objectid (usually 6)"
	int64 	num_devices
	uint32	sectorsize
	uint32	nodesize
	uint32	leafsize
	uint32	stripesize
	uint32	sys_chunk_array_size
	int64 	chunk_root_generation
	hex 8		compat_flags
	hex 8		compat_ro_flags // only implementations that support the flags can write to the filesystem
	hex 8		incompat_flags // only implementations that support the flags can use the filesystem
	uint16	csum_type // Btrfs currently uses the CRC32c little-endian hash function with seed -1.
	byte		root_level
	byte		chunk_root_level
	byte		log_root_level

	section "DEV_ITEM data for this device"
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
	endsection

	char[256] label
	int64 	cache_generation
	int64 	uuid_tree_generation

	section "skipping 240 reserved bytes"

	move 240
	
	section "Chunk Array"

	//sizing the array correctly requires a bit of trickery, as template
	//cannot have two loops within each other - and using an offset as a
	//loop control variable doesn't work anyhow

	//the first one is a given
		section "1st Array Entry Key"
		int64		"Object ID"
		byte		"Item type"
		int64		"Offset"

		section "Chunk Item Header"
		int64		"size of chunk (bytes)"
		int64		"root referencing this chunk (2)"
		int64		"stripe length"
		int64		"type" // (same as flags for block group?)
		uint32	"optimal io alignment"
		uint32	"optimal io width"
		uint32	"min. io size (sector size)"
		uint16	StripeCount1
		uint16	"sub stripes"

		numbering 0 {		
			section "Stripe ~"
			int64		"device id"
			int64		offset
			GUID		"device UUID"
	
		} [StripeCount1] 

	//room for more?

	ifGreater sys_chunk_array_size (65+StripeCount1*32)
		section "2nd Array Entry Key"
		int64		"Object ID"
		byte		"Item type"
		int64		"Offset"

		section "Chunk Item Header"
		int64		"size of chunk (bytes)"
		int64		"root referencing this chunk (2)"
		int64		"stripe length"
		int64		"type" // (same as flags for block group?)
		uint32	"optimal io alignment"
		uint32	"optimal io width"
		uint32	"min. io size (sector size)"
		uint16	StripeCount2
		uint16	"sub stripes"

		numbering 0 {		
			section "Stripe ~"
			int64		"device id"
			int64		offset
			GUID		"device UUID"
	
		} [StripeCount2] 

		//room for even more?
		section "Max. 2 Chunk Array entries parsed!"
	else
		section "Only 1 Chunk Array entry in use"
	endif

	goto 2859  //offset of next structure

	section "Super Roots"

	hex 8	"anfang"

end