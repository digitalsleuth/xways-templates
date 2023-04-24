template "DMG Footer - koly"

//Template by Jens Kirschner

//The template parses the koly block at the end of a 
//compressed DMG file (uncompressed DMG files are 
//actually identical to raw images, i.e. like dd)

description "x64 only! Apply to last 512 Bytes of DMG file"
big-endian

requires 0x00 "6B 6F 6C 79" //koly
begin
        char[4]	"Signature: koly"
        uint32 "Version (4)"       
        uint32 "HeaderSize (512)"
        uint32 Flags             
        int64 RunningDataForkOffset
        int64 DataForkOffset        // Where data in file actually starts
        int64 DataForkLength        // How much data there actually is (not counting metadata following)
        int64 RsrcForkOffset        // Resource fork offset, if any
        int64 RsrcForkLength        // Resource fork length, if any
        uint32 SegmentNumber        
        uint32 SegmentCount         
        guid   SegmentID          // 128-bit GUID identifier of segment (if SegmentNumber !=0)


		section "Data Fork Checksum"
		uint32 DataChecksumType
        uint32 DataChecksumSize
		numbering 0 {
		uint32 "DataChecksum ~"
		} [(DataChecksumSize/32)]   //only display those checksum fields actually used

		move (128-(DataChecksumSize/8))  //and skip the ones not used

		endsection

        int64 XMLOffset  
        int64 XMLLength  
        move 120 //skipping 120 reserved bytes

		section "Master Checksum"
		uint32 ChecksumType
        uint32 ChecksumSize
		numbering 0 {
		uint32 "MasterChecksum ~"      
		} [(ChecksumSize/32)]   //only display those checksum fields actually used

		move (128-(ChecksumSize/8))   //and skip the ones not used

		endsection

        uint32 ImageVariant
        int64 DecompressedSectorCount  

      //another 12 reserved bytes missing here

	section "XML PList at XMLOffset"

		gotoex XMLOffset //the template now moves to a location in front of the actual koly

		char [XMLLength] "XML PList"
end