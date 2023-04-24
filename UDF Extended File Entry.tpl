template "UDF Extended File Entry"
description "To be applied to a sector containing a UDF Extended File Entry"

//by Jens Kirschner

applies_to disk
sector-aligned
requires 0 "0A 01" //0x010A or 266 is the tag identifier for Extended File Entries

begin
section "Descriptor Tag"
	uint16	tagIdent
	uint16	descVersion
	uint8		tagChecksum
	hex 1		reserved
	uint16	tagSerialNum
	uint16	descCRC
	uint16	descCRCLength
	uint32	tagLocation

section "ICB Tag"
	uint32	priorRecordedNumDirectEntries
	uint16	strategyType
	uint16	strategyParameter
	uint16	numEntries
	hex 1		reserved
	uint8		fileType
	uint32	parentLogBlockNo
	uint16	parentPartRefNo
	hex 2		flags
endsection
	
	uint32	UID
	uint32	GID
	hex 4		permissions
	uint16	fileLinkCount
	uint8		recordFormat
	hex 1		recordDisplayAttr
	uint32	recordLength
	int64		informationLength
	int64		objectSize
	int64		logicalBlocksRecorded
	
section "Access timestamp"
	hex 2		typeAndTimezone
	uint16	year
	uint8		month
	uint8		day
	uint8		hour
	uint8		minute
	uint8		second
	uint8		centiseconds
	uint8		hundredsOfMicroseconds
	uint8 	microseconds	
	
section "Modified timestamp"
	hex 2		typeAndTimezone
	uint16	year
	uint8		month
	uint8		day
	uint8		hour
	uint8		minute
	uint8		second
	uint8		centiseconds
	uint8		hundredsOfMicroseconds
	uint8 	microseconds	
	
section "Creation timestamp"
	hex 2		typeAndTimezone
	uint16	year
	uint8		month
	uint8		day
	uint8		hour
	uint8		minute
	uint8		second
	uint8		centiseconds
	uint8		hundredsOfMicroseconds
	uint8 	microseconds	

section "Attribute timestamp"
	hex 2		typeAndTimezone
	uint16	year
	uint8		month
	uint8		day
	uint8		hour
	uint8		minute
	uint8		second
	uint8		centiseconds
	uint8		hundredsOfMicroseconds
	uint8 	microseconds	
endsection

	uint32	checkpoint
	hex 4		reserved

section "Extended Attribute ICB"	
	uint32	extLength
	uint32	logBlockNo
	uint16	partRefNo
	hex 6		implementationUse
	
section "Stream Directory ICB"	
	uint32	extLength
	uint32	logBlockNo
	uint16	partRefNo
	hex 6		implementationUse

section "Implementation ID"
	hex	1			flags
	char[23]	ident
	hex 8			identSuffix
endsection
	
	int64		uniqueID
	uint32	lengthExtendedAttr
	uint32	lengthAllocDescs
	
	ifGreater lengthExtendedAttr 0
		hex lengthExtendedAttr	extendedAttr
	endif

	ifGreater lengthAllocDescs	0
		hex lengthAllocDescs		allocDescs
	endif


end