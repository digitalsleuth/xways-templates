template "QNX6 Directory Entry"

//Created by Jens Kirschner, 2021

//Yeah, I know, there isn't much there, but that is all the directory entries have
//to offer in QNX, so...

description "Parses inode numbers for entry"
multiple

begin
	uint32	Inode
	byte		NameLength

	ifGreater NameLength 27
		section "Long name stored separately"
	else
		char[27] Filename
	Endif

end