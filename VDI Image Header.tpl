template "VDI Image Header"

//Template by Jens Kirschner

//The template parses the VDI Image basics stored at the beginning
//of the (not interpreted!) image file

description "Apply to uninterpreted VDI"

applies_to file

begin
	gotoex 0  //fixed start at offset 0

	char[64] "Oracle VDI sig"  //signature actually only 40 chars long, rest zeros

	hexadecimal uint32 "Magic (BEDA107F)"
	hex 4 "Version"
	
	uint32 "Size of this header"

	uint32 "Image type" //1=sparse, 2=fixed, 4=diff
	uint32 "Image flags"

	char[256] "Image comment" //likely empty

	uint32 "Ofs BlockArray"  //where the translation array starts
	uint32 "Ofs Data"			 //where the actual contents start

	section "Legacy Geometry"
		uint32 Cylinders
		uint32 Heads
		uint32 Sectors
		uint32 "Sector size"
	endsection

	hex 4 Dummy

	int64	"Disk size (bytes)"

	uint32 "VDI block size"

	uint32 "VDI block extra size"  //prepended before block data, if applicable; may be 0
	
	uint32 "Block count"
	uint32 "Allocated blocks"

	GUID "Creation UUID"
	GUID "LastModUUID"
	
	section "Parent Image UUIDs"
		GUID "Creation UUID"
		GUID "LastModUUID"
	endsection

	section "LCHS Geometry"
		uint32 Cylinders
		uint32 Heads
		uint32 Sectors
		uint32 "Sector size"
	endsection
end