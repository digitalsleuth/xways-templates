template "UDF File Entry"
description "To be applied to a sector containing a UDF File Entry"

//by Jens Kirschner

applies_to disk
sector-aligned
requires 0 "05 01" //0x0105 or 261 is the tag identifier for File Entries

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

section "Extended Attribute ICB"	
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