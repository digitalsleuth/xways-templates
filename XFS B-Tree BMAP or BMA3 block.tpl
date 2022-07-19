template "XFS B-Tree BMAP/BMA3 block"
description "These blocks are B-Tree nodes"  

//by Jens Kirschner

// Automatically recognises which version (with or without CRC) it is dealing
// with and supports either

applies_to disk
sector-aligned
big-endian 		//SGI IRIX inheritance

requires 0x00 "42 4D 41"  //BMA

begin
	uint32 "Magic"     //numeric evaluation for comparison operations below
	move -4
	endsection  //ASCII just for display
	
	char[4]	"Magic: BMA*"
	
	ifEqual Magic 1112359248  //BMAP
		section "BMAP: CRC not enabled"
		endsection
	EndIf

	ifEqual Magic 1112359219  //BMA3
		section "BMA3: CRC enabled"
		endsection
	EndIf

	uint16	"Level in B-Tree"  
				//0: contains extents, >0: points to further interior nodes

	uint16	"NumEntries" //Extents or node pointers

	//those two are shown in hex, as they are often FFFFFFFFFFFFFFFF anyway
	hex 8 	"Left Sibling"
	hex 8	"Right Sibling"
	
	ifEqual Magic 1112359248
		section "No CRC block"
	Else
		section "CRC block"
		int64 "This sector"
		int64 LastSeqNo
		GUID  UUID
		int64	"Owner (Inode)"
		little-endian uint32 CRC
		move 4 //skipping padding
	EndIf	
	
	section "Extents"

	ifEqual "Level in B-Tree" 0
		numbering 0
		{
			hex 16 "Extent ~"
		} [NumEntries]	
	else
		numbering 0
		{
			int64 "LBN f ptr ~"
		} [NumEntries]	

		section "Pointers; only works for 4KB block size!"

		//this is the problem - this offset is correct only for 4KB blocks
		goto 2056  

		numbering 0
		{
			int64 "Block ptr ~"   //block pointers in XFS style, of course!
		} [NumEntries]	
	EndIf



end