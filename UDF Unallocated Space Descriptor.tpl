template "UDF Unallocated Space Descriptor"
description "To be applied to a sector containing a UDF Unallocated Space Descriptor"

//by Jens Kirschner

applies_to disk
sector-aligned
requires 0 "07 00" //0x0007 is the tag identifier for Unallocated Space Descriptors

begin
section "Descriptor Tag"
	uint16	tagIdent
	uint16	descVersion
	uint8		tagChecksum
	hex 1		reserved
	uint16	tagSerialNum
	uint16	descCRC
	uint16	descCRCLength
	uint32	tagLocation
endsection

	uint32	VolumeDescSeqNo
	uint32	NoOfAllocDescriptors
	
	ifGreater NoOfAllocDescriptors 0
	
		numbering  1
		{	
			section "Extent #~"
			uint32	"extentLength (bytes)"
			uint32	"extentLocation (sector)"
		} [NoOfAllocDescriptors]
	
	else
		section "No allocation descriptors"
	endif
	
	
end