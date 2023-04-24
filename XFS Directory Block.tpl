template "XFS Directory Block"
description "For limitations, see comments in source!"

//by Jens Kirschner

applies_to disk
sector-aligned
big-endian 		//SGI IRIX inheritance

// This template supports both the the CRC enabled (XDB3/XDD3) 
// and the original (XD2B/XD2D) versions of the directory blocks 
// and automatically recognises which format it needs

// NOTE:
// This template comes with rather significant limitations as 
// it cannot tell how many entries there actually are and thus 
// has been written to simply show 20 - if there are more, the 
// remainder are missing, but if there are fewer, then all the 
// entries beyond the last real one will show random rubbish
// values.

// For single block directories (Signature XD2B/XDB3) it might also
// be worth noting that there are hash lookup tables and the tail
// information at the end of the block, which this template 
// ignores - partly, because there's only marginal value in it for
// looking at the directory structures and partly because without
// that distinction, this template works for both single block and
// multiple block directories.


begin
	uint32	Magic //numerical treatment for evaluation purposes
	move -4
	endsection

	char[4]	"Magic: XD2? or XD?3"  //ASCII treatment for visual purposes
	
	ifEqual Magic 1480868403  //XDB3
		section "XDB3: Single block; CRC enabled"
	EndIf

	ifEqual Magic 1480868915  //XDD3
		section "XDD3: Multi-block; CRC enabled"
	EndIf

	ifEqual Magic 1480864322  //XD2B
		section "XD2B: Single block; no CRC"
	EndIf

	ifEqual Magic 1480864324  //XD2D
		section "XD2D: Multi-block; no CRC"
	EndIf
	
	ifGreater Magic 1480864324  //true if we are dealing with a CRC-enabled variant
		section "CRC fields"
		uint32	CRC
		int64	"This sector"
		int64	"Last Write Seq."
		GUID	UUID
		int64	"Owner (Inode)"
	endIf

	numbering 1
	{
		section	"Best free ~"
		uint16	Offset
		uint16	Length
	} [3]

	ifGreater Magic 1480864324  //true if we are dealing with a CRC-enabled variant
		move 4 //skipping padding
	endif
	
	
	section "Shows exactly 20 entries/free segments!"
	//regardless of whether they actually exist or not...	
	
	numbering 1 {
	
	endsection
	hexadecimal uint16	"FreeTag ~"

	ifEqual "FreeTag ~" 65535
		uint16	"Size of free segment"
		uint16	"tag"

		move "Size of free segment" 
		move -6
	else	
		move -2
		section "Used entry:"
		int64	"Inode number"
		uint8	NameLen
		char[NameLen]	"Name"
		
		ifGreater Magic 1480864324  //true if we are dealing with a CRC-enabled variant
			uint8 "FType: 1=reg,2=dir,7=symlink"		
			uint16	"tag"		

			//this rounds our position up to the nearest multiple of 8
			move	((8-((4+NameLen)%8))&7)   //yes, this is a calculation to think about... ;-)
		else
			uint16	"tag"		

			//this rounds our position up to the nearest multiple of 8
			move	((8-((3+NameLen)%8))&7)   //spot the difference...
		EndIF

	endif
	} [20]	
	
end