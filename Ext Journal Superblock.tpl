template "Ext4 Journal Superblock"

//Template by Jens Kirschner

description "Apply to beginning of .journal"

sector-aligned
big-endian   //ext* are LE file systems, but the Journal is BE!

requires 0 "C0 3B 39 98 00 00 00"

begin
	section "Block Header"
	hex 4 "Jrnl Magic C0 3B 39 98"
	uint32 "Block Type (3=sblk v1, 4=sblk v2)"
	uint32 "This block's trans. ID"
	
	section "Static Jrnl Info"
	uint32 "Jrnl block size"
	uint32 "Jrnl block count"
	uint32 "First data block in Jrnl"
	
	section "Dynamic Jrnl Info"
	uint32 "First expected commit ID"
	uint32 "Current start block"
	uint32 "Error number"
	
	ifEqual "Block Type (3=sblk v1, 4=sblk v2)" 4
		section "Remaining fields in sblk v2 only"
		endsection

		hex 4 "Feature compat"
		hex 4 "Feature incompat"
		hex 4 "Feature RO compat"
		
		hex 16 "Jrnl UUID"
		
		section "Use of remaining fields dubious"		
		endsection
		
		uint32 "Num users"
		uint32 "Dyn. sblk copy location"
		uint32 "Max. trans. Jrnl blocks"
		uint32 "Max. trans. data blocks"
		uint8  "Checksum type (1=crc32, 4=crc32c)"
		
		section "Skipping 3 + 42x4 bytes of padding"
		move (3+42*4)
		
		uint32	"sblk checksum" 
		
		section "The first three of 48 users fields"
		numbering  1
        {
			hex 16 "UUID ~"
        } [3]
		
	endif
end