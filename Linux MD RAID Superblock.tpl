template "Linux MD RAID Superblock"

//Created by Jens Kirschner

description "Commonly at offset 4096 in current Linux"

//Technically, there are several subversions of the MD RAID SB,
//but the only one in common use presently is v1.2, the latest
//and most recent. It is effectively identical in layout to 
//v1.0 and v1.1, except the superblock has been relocated:
//in v1.0 it is at the end (!) of the RAID host partition and
//in v1.1 it is at offset 0. Finding it at the offset 4096 
//mentioned above automatically signifies v1.2

requires 0x0 "FC 4E 2B A9 01 00 00 00"
applies_to disk
sector-aligned

begin
	hexadecimal uint32 "Magic (A92B4EFC)"
	uint32 "Major version"	//1
	hex 4 "Feature flags"	//any of them set probably means trouble!
	move 4 //padding

	section "RAID Array Config"

	GUID "RAID UUID"
	char[32] "RAID Label"	

	UnixDateTime "Creation time"  //technically stored in 40 bit, not 32
	move 1 //see comment above
	uint24 "Creation nsec"

	int32 "RAID Level" //Positive values 0-10 speak for themselves;
							 //-4 = multi-path; -1 = linear

	int32	"Parity arrangement (5+ only)" //0 = left asymmetric; 
					//1 = right asymmetric; 2 = left symmetric; 3 = right symmetric															


	ifEqual "Parity arrangement (5+ only)" 0
		section "backward parity"   //XWF name for left asymmetric
	EndIf

	ifEqual "Parity arrangement (5+ only)" 1
		section "forward parity"  //XWF name for right asymmetric
	EndIf

	ifEqual "Parity arrangement (5+ only)" 2
		section "backward dynamic parity"  //XWF name for left symmetric
	EndIf


	ifEqual "Parity arrangement (5+ only)" 3
		section "forward dynamic parity"  //XWF name for right symmetric
	EndIf
	
	endsection


	int64 "Used component sector count" 
	uint32 "Chunk size (sectors)"

	uint32 "Num disks in array"

	goto 128

	section "This component config"

	int64	"Data start sector"
	int64 "Data sector count"
	int64 "This sector"

	goto 160

	uint16 "Drive number"

	goto 168

	GUID "Component UUID"
	
	goto 192

	UnixDateTime "Last update"  //technically stored in 40 bit, not 32
	move 1 //see comment above
	uint24 "Last update nsec"
	
	goto 256
	
	section "Drive roles/positions"

   numbering  0
	{
		hexadecimal uint16 "Drive ~ role"
		
		ifEqual "Drive ~ role" 65534
			section "Drive ~ marked faulty"
			endsection 
		endIf		
   } ["Num disks in array"]

	//theoretically, the drive with number 0 (see "Drive number" 
	//above) could take on a role that is not component 0 from the
	//RAID's point of view; most notably, a role 0xFFFF means "spare",
	//0xFFFE means "faulty".
	
end