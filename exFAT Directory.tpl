template "exFAT Directory"

// Template by Jens Kirschner

description "Parses one sector in an exFAT directory"
applies_to disk

begin
	
	numbering 1 {
		hexadecimal uint8 "TypeID ~"
		
		//The occurrences of move -31 in each section make sure that
		//the generic move 31 at the end works for all of them - thus
		//allowing the template to work even if an unknown type were
		//to show up (it would be listed but not parsed, obviously).

		ifEqual "TypeID ~" 131 //0x83: Volume Label
			section "~: Volume Label"
			uint8 		LabelLength
			char16[11]	Label
			
			move -23 //8 bytes reserved at the end
		EndIf
		
		ifEqual "TypeID ~" 3 //0x03: Empty Volume Label
			section "~: Empty Volume Label"
		EndIf
		
		ifEqual "TypeID ~" 129 //0x81: Bitmap
			section "~: Bitmap"
			hex 1			Flags
			move 18 //skipping reserved		
			uint32		"Bitmap starting cluster"
			int64			"Bitmap size"
			
			move -31
		EndIf

		ifEqual "TypeID ~" 130 //0x82: UpCase Table
			section "~: UpCase Table"
			move 3 //skipping reserved		
			uint32		"Table Checksum"
			move 12 //skipping reserved		
			uint32		"UpCase starting cluster"
			int64			"UpCase size"
			
			move -31
		EndIf

		ifEqual "TypeID ~" 160 //0xA0: GUID
			section "~: GUID"
			move 1 //skipping reserved		
			uint16		Checksum
			hex 2			Flags
			GUID			"GUID"
			
			move -21 //10 bytes reserved at the end
		EndIf

		ifEqual "TypeID ~" 133 //0x85: Ordinary directory entry
			section "~: Directory Entry"
			uint8			"Records following"
			hex 2			"Checksum of filename"  
			hex 2			"Attributes"
			move 2 //skipping reserved		

			DOSDateTime	"Created"
			DOSDateTime	"Accessed"
			DOSDateTime	"Modified"
			uint8 		"Created 10ms-refinement"
			uint8 		"Modified 10ms-refinement"
			hex 1			"Time Zone Offset Created"
			hex 1			"Time Zone Offset Modified"
			hex 1			"Time Zone Offset Accessed"
			
			move -24 //7 bytes reserved at the end
		EndIf


		ifEqual "TypeID ~" 5 //0x05: Deleted directory entry
			section "~: Del. Directory Entry"
			uint8			"Records following"
			hex 2			"Checksum of filename"  
			hex 2			"Attributes"
			move 2 //skipping reserved		

			DOSDateTime	"Created"
			DOSDateTime	"Accessed"
			DOSDateTime	"Modified"
			uint8 		"Created 10ms-refinement"
			uint8 		"Modified 10ms-refinement"
			hex 1			"Time Zone Offset Created"
			hex 1			"Time Zone Offset Modified"
			hex 1			"Time Zone Offset Accessed"
			
			move -24 //7 bytes reserved at the end
		EndIf

		ifEqual "TypeID ~" 192 //0xC0: Stream Extension
			section "~: Stream Extension"
			hex 1			Flags
			move -1
			uint_flex "1" "No FAT chain"
			move -2 //1 byte reserved

			uint8			NameLength
			uint16		NameHash
			move 2 //skipping reserved		
			int64			"Valid FileSize"
			move 4 //skipping reserved		
			uint32		"Starting Cluster"
			int64			FileSize

			move -31
		EndIf


		ifEqual "TypeID ~" 64 //0x40: Deleted Stream Extension
			section "~:Del. Stream Extension"
			hex 1			Flags
			move -1
			uint_flex "1" "No FAT chain"
			move -2 //1 byte reserved

			uint8			NameLength
			uint16		NameHash
			move 2 //skipping reserved		
			int64			"Valid FileSize"
			move 4 //skipping reserved		
			uint32		"Starting Cluster"
			int64			FileSize

			move -31
		EndIf

		ifEqual "TypeID ~" 193 //0xC1: Filename
			section "~: Filename"
			hex 1			Flags
			char16[15]	"Filename (part?)"
			
			move -31
		EndIf

		ifEqual "TypeID ~" 65 //0x41: Deleted Filename
			section "~: Del. Filename"
			hex 1			Flags
			char16[15]	"Filename (part?)"
			
			move -31
		EndIf

	
		move 31
		endsection
	} [16]	// 16x32=512

end