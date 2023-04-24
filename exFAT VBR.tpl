template "ExFAT - VBR"

// Costas Katsavounidis - 2021 v.2
// kacos2000 [at] gmail.com
// https://github.com/kacos2000

// To be applied to first sector (sector 0) of a Volume, OR
// to the last sector of a Volume

description "ExFAT - Volume Boot Record Structure"
applies_to disk
sector-aligned
read-only

requires 0x03  "45 58 46 41 54 20 20 20" // ExFAT signature, including trailing spaces
requires 0x1FE "55 AA"

begin
	section "Boot Sector Structure"
        hex 2	"JMP instruction"	 //Valid: EBh 76h 
        move 1                       //0x90 in assembly = "no op"; short for no operation    
        // https://thestarman.pcministry.com/asm/mbr/NTFSBR.htm
	    char[8]	"File System Name"
	    move 53	//skip 'MustBeZero' part - helps to prevent FAT12/16/32 implementations from mistakenly mounting an exFAT volume
	    int64	"Partition Offset"
	    int64	"Volume Length (sectors)"
	    uint32	"FAT Offset (sectors)" //At least 24. Volume-relative 
	    uint32	"FAT Length (sectors)" //length, in sectors, of each FAT table
	    uint32	"Cluster Heap Offset"
	    uint32	"Cluster Count"
	    uint32	"First Cluster Of Root Directory" //Min: 2, Max: ClusterCount + 1
	    hex 4	"Volume Serial Number" //Implementations should generate the serial number by combining the date and time of formatting the exFAT volume.
        // File System Revision
        // The high-order byte is the major revision number and the low-order byte is the minor revision number
        move 1 
        uint8  "File System Revision: Major" //Range 0-1
        move -2
        uint8  "File System Revision: Minor" //Range 0-99 
        move 1
	    hex 2   "VolumeFlags"
        move -2
            uint_flex "0" "Bit 0 - Active FAT"
	        move -4
	        uint_flex "1" "Bit 1 - Volume Dirty"
	        move -4
	        uint_flex "2" "Bit 2 - Media Failure"
	        move -4
	        uint_flex "3" "Bit 3 - Clear to Zero"
	    move -2
        uint8   "Bytes per Sector (2^x)"     //Range 9-12
        uint8   "Sectors per Cluster (2^x)"  //Range 0-25
        uint8   "Number Of Fats"             //Range 1 or (2: volume contains 1st FAT, 2nd FAT, 1st Allocation Bitmap, and 2nd Allocation Bitmap; only valid for TexFAT volumes)
	    hex 1	"Drive Select (INT 13h drive Nr)" 
                                                    //0x00: 1st floppy disk ( "drive A:" )
                                                    //0x01: 2nd floppy disk ( "drive B:" )
                                                    //..
                                                    //0x7F: 128th floppy disk 
                                                    //0x80:	1st hard disk 
                                                    //0x81	2nd hard disk 
                                                    //0x82:	3rd hard disk 
                                                    //..
                                                    //0xFF: 128th hard disk
        uint8   "% of clusters in the Cluster Heap In Use"
	    move 7  //skip 'Reserved' part
	 endsection
     Section "Boot Code"
        hex 390	"Boot Code"
     endsection
     goto 0x1FE
     Section "Signature"
        hex 2 "Boot Signature" //describes whether the intent of a given sector is for it to be a Boot Sector (=AA55h) or not
	endsection
end

// Reference:
// https://docs.microsoft.com/en-us/windows/win32/fileio/exfat-specification#31-main-and-backup-boot-sector-sub-regions