template "BSD Disklabel"

//Template by Jens Kirschner

description "To be applied to sector 1 within a disklabel partition"
applies_to disk
sector-aligned

begin
	hex 4		"Magic (57455682)"
	uint16	"Drive type"
	uint16	"Drive subtype"
	char[16]	"Type name"
	char[16]	"Pack name"
	
	section "Disk geometry"
		uint32 "Sector size"
		uint32 "Sectors per track"
		uint32 "Tracks per cylinder"
		uint32 "Data cylinders"
		uint32 "Data sectors per cylinder"
		uint32 "Data sectors (total)"
		uint16 "Spare sectors per track"
		uint16 "Spare sectors per cylinder"
		uint32 "Alternate cylinders" // maintenance, replacement, configuration description areas, etc.
	endsection

	section "Hardware characteristics"
		uint16 "RPM"
		uint16 "HW sector interleave"
		uint16 "Track skew"
		uint16 "Cylinder skew"
		uint32 "Head switch time (usec)"
		uint32 "Track seek time (usec)"
		hex 4  "Flags"
		hex 20 "Drive-specific info"
		hex 20 "reserved"
	endsection

	hex 4		"Magic (57455682)"
	uint16 	"Checksum"
	
	section "FS and partition info"
		uint16 "NumEntries"
		uint32 "Boot block size"
		uint32 "Super block size"

	
	numbering 1 {	
		section "Partition ~"	
		uint32 "Sector count"
		uint32 "Start sector"
		uint32 "FS Fragment size"
		uint8  "FS type"
		uint8  "FS Fragments per block"
		uint16 "FS cylinders per group"
	} [NumEntries]
end