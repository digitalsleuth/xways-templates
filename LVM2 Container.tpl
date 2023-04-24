template "LVM2 Container"
description "x64 only! Apply to sector 0 (!) of LVM2 Container"

// Jens Kirschner

sector-aligned
applies_to disk

begin
	section "LVM header (sector 1)"

	goto 512
	char[8] "LVM signature"
	goto (512+24)
	char[8] "LVM version"
	char[32] "PV ID"

	goto (512+72)
	Int64 OfsFirstExtent

	goto (512+104)
	Int64 OfsLVM2Header
	Int64 SizeOfMetadataArea


	section "LVM2 header (at Ofs above)"
	
	goto (OfsLVM2Header+5)
	char[4] "LVM2 magic"

	goto (OfsLVM2Header+24)
	Int64 OfsLVM2Header
	Int64 SizeOfMetadataArea
	Int64 OfsCurrentASCIIMetadata
	Int64 SizeOfCurrentASCIIMetadata

	goto (OfsLVM2Header+OfsCurrentASCIIMetadata)

	section "Current ASCII Metadata"

	char [SizeOfCurrentASCIIMetadata] "ASCII Metadata"

	goto OfsFirstExtent

	section "Beginning of first extent"

	hex 16 "First data"

end