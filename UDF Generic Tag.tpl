template "UDF Generic Tag"
description "To be applied to any sector containing a UDF Descriptor Tag"

//by Jens Kirschner

applies_to disk
sector-aligned

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

end