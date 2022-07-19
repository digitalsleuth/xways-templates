template "XFS Inode (with CRC)"
description "Apply to inodes on CRC enabled XFS"

//by Jens Kirschner

//Includes Literal Area treatment with the following conditions: 
// - CRC is in use
// - "small entries" must be used for local directories 
// - for B-Tree (format 3) Inodes only works properly for 512 Byte inodes
applies_to disk
big-endian   //SGI IRIX inheritance

requires 0 "49 4E"  //"IN"

begin
	char[2] "Magic: IN"

	section "File mode"
		//slightly strange bit order: Big Endian bits referred to by their Little Endian positions
		octal uint_flex "0,15,14,13,12,11,10,9,8" "Permissions"

		move -4
		uint_flex "7,6,5,4" "File type (8=reg.file, 4=dir.)"

		move -4
		uint_flex "1" "Sticky bit"
	
		move -4
		uint_flex "2" "SGID"

		move -4
		uint_flex "3" "SUID"

		move -2
//	endsection  --> removed, produces too much space

	section "Version 3 means CRC in use:"
	int8	Version
	endsection

	int8 Format
	uint16 "Hard link count old"
	uint32 "Owner ID"
	uint32 "Group ID"
	uint32 "Hard link count new"
	uint16 "Project ID"
	hex 8 "(unused)"
	uint16 "Flush count"
	
	UNIXDateTime "Last access"
	uint32 "Last access: nsec"
	UNIXDateTime "Modified"
	uint32 "Modified: nsec"
	UNIXDateTime "Inode change"
	uint32 "Inode change: nsec"

	int64 "File size"
	int64 "Block count"
	uint32 "Extent size"
	int32 NumExtents
	uint16 NumEAextents
	uint8 "EA Fork Offset"
	int8 "EA Format"
	uint32 "DMAPI event mask"
	uint16 "DMAPI state"
	hex 2 Flags
	uint32 Generation

	int32	"Next unlinked pointer"


ifGreater Version 2
	section "v3 Extra Fields"
		uint32	CRC
		int64		"Attr. changes"
		int64		"Flush sequence"
		hex 8		Flags2
		move 16 //skipping padding
		UNIXDateTime "Creation"
		uint32 "Creation: nsec"		
		int64		"Inode number"
		GUID	UUID
//	endsection
else
	section "No CRC - use other inode template"
	exit   //Literal Area treatment likely to fail with wrong template
endIf
	
	ifEqual "File type (8=reg.file, 4=dir.)" 10
		section "Literal Area: Symlink"
		zString "SymLink target"
		Exit  //prevents the next option being applied in addition
	EndIf

	ifEqual Format 1  //Local, but not SymLink (that one covered above)
		section "Literal Area: Local Directory"	
	
		uint8	"entries"
		uint8	"largeEntries"
		
		uint32	"Parent inode"
		
		numbering 0 {
			section "Entry ~"

			uint8 "namelen"
			uint16	"offset"
			char[namelen] "Name"
			uint8 "FType: 1=reg,2=dir,7=symlink"
			uint32	"inode"
			move -4 
			hex 4	"inode (hex)"
		}[entries]
	EndIf	

	ifEqual Format 2  //Extents
		section "Literal Area: Extents"
		
		numbering 0
		{
			hex 16 "Extent ~"
		} [NumExtents]	
	endif


	ifEqual Format 3  //B-Tree
		uint16	"Level in B-Tree"
		uint16	NumPointers

		section "Log. block no.s f pointers"
			
		numbering 0
		{
			int64 "LBN f ptr ~"
		} [NumPointers]	

		section "Pointers; only works for 512B inodes!"

		//this is the problem - this offset is correct only for 512B inodes
		goto 340  

		numbering 0
		{
			int64 "Block ptr ~"   //block pointers in XFS style, of course!
			move -8
			hex 8 "Block ptr ~ (hex)"
		} [NumPointers]		
	endif
end