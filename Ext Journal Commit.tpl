template "Ext4 Journal Commit Record"

//Template by Jens Kirschner

description "Apply to block of type 2"

sector-aligned
big-endian   //ext* are LE file systems, but the Journal is BE!

requires 0 "C0 3B 39 98"

begin
	section "Block Header"
	hex 4 "Jrnl Magic C0 3B 39 98"
	uint32 "Block Type (2=commit record)"
	uint32 "This block's trans. ID"	
	endsection
	
	uint8 "Checksum type (1=CRC32, 4=CRC32C)"
	uint8 "Checksum size"
	hex 2 "Padding"
	
	section "32 B to store checksums in"
	hex 16 "First 16 bytes"
	hex 16 "Second 16 bytes"
	endsection
	
	hex 4 "HiDWord commit time"
	UNIXDateTime "Commit time"
	
	uint32 "Commit time nsecs"

end