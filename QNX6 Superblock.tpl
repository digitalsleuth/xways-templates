template "QNX6 Superblock"

//Created by Jens Kirschner, 2021

description "To be applied to Offset 0x2000 of a QNX volume"
applies_to disk
requires 0x00 "22 11 19 68"

begin
	hex 4		"QNX6 Magic (22 11 19 68)"
	uint32	"Checksum"
	int64		Serial
	UNIXDateTime "Creation or OEM-specific"
	move -4
	uint32	"Creation or OEM-specific"
	
	UNIXDateTime "Last (write?) access"
	Hex 4		"Flags"
	uint16	"FS version 1"
	uint16	"FS version 2"

	guid		"Volume ID"
	uint32	"Block size"
	uint32	"Inode count"
	uint32	"Free inodes"
	uint32	"Block count"
	uint32	"Free blocks"
	uint32	"Alloc group"

	section "Root Node Inodes"
		int64	Size
		numbering 0 {
			uint32	"BlockPtr ~"
		} [16]
		byte	Levels
		byte	Mode
		hex 6 spare
	
	section "Root Node Bitmap"
		int64	Size
		numbering 0 {
			uint32	"BlockPtr ~"
		} [16]
		byte	Levels
		byte	Mode
		hex 6 spare

	section "Root Node Longnamefile"
		int64	Size
		numbering 0 {
			uint32	"BlockPtr ~"
		} [16]
		byte	Levels
		byte	Mode
		hex 6 spare


	section "Root Node Unknown"
		int64	Size
		numbering 0 {
			uint32	"BlockPtr ~"
		} [16]
		byte	Levels
		byte	Mode
		hex 6 spare
end