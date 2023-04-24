template "EVF2 Header"

//by Jens Kirschner, 2022

description "Apply to beginning of non-interpreted Ex01 Image"
applies_to file

begin
	char[4] "EVF2"
	hex 4	"0D 0A 81 00"

	Byte	"Major version (2)"
	Byte	"Minor version (1)"

	uint16	"Compression 1=zlib/2=bz2"
	uint32	"Segment file number"

	guid	"Segment set GUID"
end