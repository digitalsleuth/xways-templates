template "BtrFS Extent Only"

//Created by Jens Kirschner, 2020
//The challenge here is working out where exactly the extent 
//structure starts, of course...

description "To be applied to beginning of an extent structure"
applies_to disk

begin
	section "EXTENT DATA"
	section "(Taking your word for it: Good luck!)"

	int64	generation
	int64	"DecodedExtentSize"
	byte	"compression (1=zlib, 2=LZO)"
	byte	encryption
	uint16	"other encoding"
	byte	"ExtentType" // (0=inline, 1=reg, 2=prealloc)


	ifEqual ExtentType 2
		section "Type 2: Preallocation only!"
	endif


	ifEqual ExtentType 0
		section "Type 0: inline data!"

		{
			char[128] "data as text"

		} [((DecodedExtentSize-1)/128+1)]

		endsection

		{
			hex 32	"data in hex"

		} [((DecodedExtentSize-1)/32+1)]


	else
		int64	"log. address"
		int64	"extent size"
		int64	"Ofs in file"
		int64	"file size"
	EndIf

end