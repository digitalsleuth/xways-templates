template "BPList Tail"

//Template by Jens Kirschner

description "To be applied to the last byte of a BPList"
big-endian

begin
	move -25
	byte	SizeOfsIntsInOfsTable
	byte	SizeObjRefs
	int64	NumElements
	int64	TopLevelElement
	int64	OfsTableOfs

	gotoex OfsTableOfs

	
	numbering 0
	{
		ifEqual SizeOfsIntsInOfsTable 1
			byte "Offset ~"
		endif

		ifEqual SizeOfsIntsInOfsTable 2
			uint16 "Offset ~"
		endif

		ifEqual SizeOfsIntsInOfsTable 4
			uint32 "Offset ~"
		endif

		ifEqual SizeOfsIntsInOfsTable 8
			int64 "Offset ~"
		endif

   } [(NumElements-1)]


	
	
	
	
end