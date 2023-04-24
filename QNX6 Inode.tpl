template "QNX6 Inode"

//Created by Jens Kirschner, 2021

description "To be applied to a QNX inode"
applies_to disk
multiple

begin
 	int64	Filesize
	uint32	Owner
	uint32	Group
	UNIXDateTime "Creation ?"  //the question mark seems justified, as some manufacturers clearly do not use this as a date
	UNIXDateTime Modification
	UNIXDateTime Access
	UNIXDateTime "Inode change"
	
	section "File mode"
		octal uint_flex "8,7,6,5,4,3,2,1,0" "Permissions"
		move -4
		uint_flex "15,14,13,12" "File type (8=reg.file, 4=dir.)"
		move -4
		uint_flex "9" "Sticky bit"
		move -4
		uint_flex "10" "SGID"
		move -4
		uint_flex "11" "SUID"
		move -2
		hex 2 "Mode extra"
	endsection

	numbering 0 {
		uint32	"BlockPtr ~"
	} [16]
	byte	Levels
	byte	Mode
	hex 2 unknown

	hex 12 "spare"
	hex 12 "spare"
end