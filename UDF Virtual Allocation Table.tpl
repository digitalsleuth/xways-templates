template "UDF Virtual Allocation Table"
description "To be applied to the beginning of the UDF VAT"

//by Jens Kirschner


applies_to disk
sector-aligned

begin
	uint16	HeaderLen
	uint16	IULen
	char16[64]	"Volume ID"
	uint32	"Prev VAT"
	
	Uint32	"Num Files" 
	Uint32	"Num Directories" 
	hexadecimal		Uint16	"Min. UDF Read Rev." 
	hexadecimal		Uint16	"Min. UDF Write Rev." 
	hexadecimal		Uint16	"Max. UDF Write Rev." 
	hex 2 	Reserved

	ifGreater IULen 0
		hex IULen "Implementation Use"
	EndIf

	section "First 128 VAT entries - there may be more or fewer!"

	numbering  0
	{
		uint32	"VAT entry ~"
	} [127]

end