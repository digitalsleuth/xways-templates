template "EVF2 Section Header"

//by Jens Kirschner, 2022

description "x64 only; apply 64 bytes from *end* of file!"
applies_to file  //only works for non-interpreted Ex01

begin

section "Sections in back-to-front order!"

numbering 1 {
	endsection
	uint32	"Section type"

	ifEqual "Section type" 1
		Section "Type: Device information"
	endif

	ifEqual "Section type" 2
		Section "Type: Case data"
	endif

	ifEqual "Section type" 3
		Section "Type: Sector data"
	endif

	ifEqual "Section type" 4
		Section "Type: Sector table"
	endif

	ifEqual "Section type" 5
		Section "Type: Error table"
	endif

	ifEqual "Section type" 6
		Section "Type: Session table"
	endif

	ifEqual "Section type" 7
		Section "Type: Increment data"
	endif

	ifEqual "Section type" 8
		Section "Type: MD5 hash"
	endif

	ifEqual "Section type" 9
		Section "Type: SHA-1 hash"
	endif

	ifEqual "Section type" 10
		Section "Type: Restart data"
	endif

	ifEqual "Section type" 11
		Section "Type: Encryption keys"
	endif

	ifEqual "Section type" 12
		Section "Type: Memory extents table"
	endif

	ifEqual "Section type" 13
		Section "Type: Next"
	endif

	ifEqual "Section type" 14
		Section "Type: Final information"
	EndIf

	ifEqual "Section type" 15
		Section "Type: Done"
	endif

	ifEqual "Section type" 16
		Section "Type: Analytical data"
	endif

	ifEqual "Section type" 1
		Section "Type: Device information"
	endif

	hex 4		"Data flags"

	int64		PrevSectionOffset

	int64		"Data size"
	uint32	"Section descr. size"
	uint32	"Padding size"
	hex 16	"MD5 of data+padding"
	hex 12	"empty padding"
	uint32	"Adler32 of the above"

	ifGreater PrevSectionOffset 0
		gotoex PrevSectionOffset
	else
		exit
	Endif

} [20] //arbitrary limit to prevent endless loops in case of error

end