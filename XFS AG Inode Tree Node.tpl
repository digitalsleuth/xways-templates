template "XFS AG Inode Tree Node v2"
description "Apply to an XFS Inode Tree Node (CRC optional)"

//by Jens Kirschner

// Automatically recognises which version (with or without CRC) it is dealing
// with and supports either

applies_to disk
sector-aligned
big-endian 		//SGI IRIX inheritance

begin
	uint32 "Magic"     //numeric evaluation for comparison operations below
	move -4
	endsection  //ASCII just for display
	
	char[4]	"Magic: IAB*"
	
	ifEqual Magic 1229013588  //IABT
		section "IABT: CRC not enabled"
		endsection
	EndIf

	ifEqual Magic 1229013555  //IAB3
		section "IAB3: CRC enabled"
		endsection
	EndIf
	
	
	uint16	"Level"
	uint16	"NumRecords"
	hex 4	"left sibling"
	hex 4	"right sibling"
	
	ifEqual Magic 1229013588
		section "No CRC block"
	Else
		section "CRC block"
		int64 "This sector"
		int64 LastSeqNo
		GUID  UUID
		uint32	Owner
		little-endian uint32 CRC
	EndIf	
	
	

	ifEqual Level 0 
		{
			endsection
			uint32	"Start Inode"
			uint32	"Free Count" 
			hex 8		"Free bitmap"
		}[NumRecords]
	else
		numbering 1 
		{
			uint32	"Start Inode ~"	
		}[NumRecords]

		numbering 1
		{
			uint32	"Pointer ~"
		}[NumRecords]
	endIf
end