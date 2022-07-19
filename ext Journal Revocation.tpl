template "Ext4 Journal Revocation Block"

//Template by Jens Kirschner

description "Apply to block of type 5"

sector-aligned
big-endian   //ext* are LE file systems, but the Journal is BE!

requires 0 "C0 3B 39 98"

begin
	section "Block Header"
	hex 4 "Jrnl Magic C0 3B 39 98"
	uint32 "Block Type (5=revocation block)"
	uint32 "This block's trans. ID"	
	endsection
	
	uint32 BytesUsed
	
	section "Assuming 32 bit block no.s!"
	
	{	
		uint32 "Revoked block number"
	} [((BytesUsed-16)/4)]
	
	//Revoked blocks are those that have been turned from
	//file system metadata blocks into file content blocks.
	//Since the latter are not journaled, replaying journal
	//transactions that refer to them would irrevocably 
	//cause the now-contained data to be lost.

end