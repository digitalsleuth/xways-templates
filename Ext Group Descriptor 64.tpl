template "Ext4 64-bit Group Descriptor"

// Created by Jens Kirschner 

description "Locates the meta blocks for a block group"
applies_to disk
sector-aligned
multiple

begin
	uint32	"Block bitmap block (lo4)"
	uint32	"Inode bitmap block (lo4)"
	uint32	"Inode table block (lo4)"
	uint16	"Free blocks count (lo2)"
	uint16	"Free Inodes count (lo2)"
	uint16	"Directories count (lo2)"
	uint16	"Flags"	
	uint32	"Snapshot excl. bitmap (lo4)"
	uint16	"Block bitmap checksum (lo2)"
	uint16 	"Inode bitmap checksum (lo2)"
	uint16	"Never used inode count (lo2)"
	uint16 	"Grp desc checksum"	

	section "64-bit section"
	
	uint32	"Block bitmap block (hi4)"
	uint32	"Inode bitmap block (hi4)"
	uint32	"Inode table block (hi4)"
	uint16	"Free blocks count (hi2)"
	uint16	"Free Inodes count (hi2)"
	uint16	"Directories count (hi2)"
	uint16	"Never used inode count (hi2)"
	uint32	"Snapshot excl. bitmap (hi4)"
	uint16	"Block bitmap checksum (hi2)"
	uint16 	"Inode bitmap checksum (hi2)"
	uint32	"Reserved"
end
