template "XFS AG Free Space Tree Node v2"
description "Apply to an XFS Free Space Tree Node (CRC optional)"

//by Jens Kirschner

// Automatically recognises which version (with or without CRC) it is dealing
// with and supports either

applies_to disk
sector-aligned
big-endian 		//SGI IRIX inheritance

begin
	uint32 "Magic"     //numeric evaluation for comparison operations below
	move -4
	endsection 
	
	char[4]	"ABT* or AB3* Magic"    //ASCII just for display

	ifEqual Magic 1094857538  //AB3B
		section "AB3B: BlockSort; CRC enabled"
		endsection
	EndIf

	ifEqual Magic 1094857539  //AB3C
		section "AB3C: CountSort; CRC enabled"
		endsection
	EndIf

	ifEqual Magic 1094865986  //ABTB
		section "ABTB: BlockSort; no CRC"
		endsection
	EndIf

	ifEqual Magic 1094865987  //ABTC
		section "ABTC: CountSort; no CRC"
		endsection
	EndIf
	
	uint16	"Level"
	uint16	"NumRecords"
	uint32	"left sibling"
	uint32	"right sibling"

	ifGreater Magic 1094857539
		section "No CRC block"
	Else
		section "CRC block"
		int64 "This sector"
		int64 LastSeqNo
		GUID  UUID
		uint32	Owner
		little-endian uint32 CRC
	EndIf

	numbering 1
	{
		endsection

		uint32	"Start Block ~"
		uint32	"Block Count ~" 
	}[NumRecords]

	ifGreater Level 0
		//the location of the child node pointers depends on the 
		//block size used in the file system *and* on the exact 
		//tree version we are using -- too much for a template to
		//consider

		section "Child node pointers not accessible in template"
		section "Sorry"
	endIf
end