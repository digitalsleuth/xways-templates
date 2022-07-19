template "Linux MD RAID Reconstruction"

//Created by Jens Kirschner

description "Commonly at offset 4096 in current Linux"

//This is the Linux MD RAID Superblock template boiled down
//to just the stuff we actually need for RAID Reconstruction

requires 0x0 "FC 4E 2B A9 01 00 00 00"
applies_to disk
sector-aligned

begin
	move 72  //	only cold hard facts, remember

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

	move 8
	
	uint32 "Stripe size"

	uint32 "Num disks in array"

	goto 128

	int64	"This drive Header size"

	goto 160

	uint16 "Drive number"

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